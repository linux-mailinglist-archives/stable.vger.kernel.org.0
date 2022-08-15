Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A573593FB8
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:46:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348939AbiHOViH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:38:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349069AbiHOVgf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:36:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77882106;
        Mon, 15 Aug 2022 12:26:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 17339610A1;
        Mon, 15 Aug 2022 19:26:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03484C433D6;
        Mon, 15 Aug 2022 19:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591578;
        bh=90CmysPOl4jxfz6UiU92ZjhnuJQTM2s168P8efW9v3g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O5+WZVxpu0cQEikcLu4c5RLS9jTrDgcxbgpi6o+1YASJmfwVwChjh72qNUthcu1OE
         b8+r8XF6BEAX/pWjoV1IbLq7P61QgVUTJ31QPCTVh/gKhLPBteJv8266/jYchFZSyw
         xfgMIfa2fK7GxycPhfj2Y3SbokCdaO0T6nOu3V1k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0576/1095] scsi: qla2xxx: edif: Fix no login after app start
Date:   Mon, 15 Aug 2022 19:59:35 +0200
Message-Id: <20220815180453.398646937@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

[ Upstream commit 24c796098f5395477f7f7ebf8e24f3f08a139f71 ]

The scenario is this: User loaded driver but has not started authentication
app. All sessions to secure device will exhaust all login attempts, fail,
and in stay in deleted state. Then some time later the app is started. The
driver will replenish the login retry count, trigger delete to prepare for
secure login. After deletion, relogin is triggered.

For the session that is already deleted, the delete trigger is a no-op. If
none of the sessions trigger a relogin, no progress is made.

Add a relogin trigger.

Link: https://lore.kernel.org/r/20220608115849.16693-5-njavali@marvell.com
Fixes: 7ebb336e45ef ("scsi: qla2xxx: edif: Add start + stop bsgs")
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_edif.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index 208a16cb54f0..9020cc3c61df 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -567,6 +567,7 @@ qla_edif_app_start(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 			qlt_schedule_sess_for_deletion(fcport);
 			qla_edif_sa_ctl_init(vha, fcport);
 		}
+		set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
 	}
 
 	if (vha->pur_cinfo.enode_flags != ENODE_ACTIVE) {
-- 
2.35.1



