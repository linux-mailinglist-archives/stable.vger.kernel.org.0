Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4E9B50148C
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245083AbiDNOCo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 10:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344678AbiDNNwe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:52:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 979E139B82;
        Thu, 14 Apr 2022 06:44:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7FC0761D73;
        Thu, 14 Apr 2022 13:44:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90951C385A5;
        Thu, 14 Apr 2022 13:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649943875;
        bh=W5QWPyaHFRaq2b92HERDe8A1sPybpn53d6oBFD2u1T4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YvuSuJzdYX73XfuU8znP8S+iVgLns6BveLE66iVGrKqUkydLHF2C5L/j5+w/GRIxk
         EbKcTBAiDcrwI1UWSqhlzXqkM0BP6NdWqC6m86aPI756mi9TdZaVcWB3PiNjTvHlAa
         pmFgWjeHudwwmGqJY83GEcBpVvQVSKinMxI2iAXk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.4 314/475] scsi: qla2xxx: Fix stuck session in gpdb
Date:   Thu, 14 Apr 2022 15:11:39 +0200
Message-Id: <20220414110903.876141698@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,PDS_OTHER_BAD_TLD,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

commit 725d3a0d31a51c0debf970011e05f585e805165b upstream.

Fix stuck sessions in get port database. When a thread is in the process of
re-establishing a session, a flag is set to prevent multiple threads /
triggers from doing the same task. This flag was left on, where any attempt
to relogin was locked out. Clear this flag, if the attempt has failed.

Link: https://lore.kernel.org/r/20220110050218.3958-4-njavali@marvell.com
Cc: stable@vger.kernel.org
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_init.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1314,9 +1314,9 @@ int qla24xx_async_gpdb(struct scsi_qla_h
 	if (!vha->flags.online || (fcport->flags & FCF_ASYNC_SENT) ||
 	    fcport->loop_id == FC_NO_LOOP_ID) {
 		ql_log(ql_log_warn, vha, 0xffff,
-		    "%s: %8phC - not sending command.\n",
-		    __func__, fcport->port_name);
-		return rval;
+		    "%s: %8phC online %d flags %x - not sending command.\n",
+		    __func__, fcport->port_name, vha->flags.online, fcport->flags);
+		goto done;
 	}
 
 	sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);


