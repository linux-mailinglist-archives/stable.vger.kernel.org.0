Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE0A59DFA0
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352987AbiHWKJx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:09:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352715AbiHWKIf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:08:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0D696DFA0;
        Tue, 23 Aug 2022 01:54:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 30426B81C52;
        Tue, 23 Aug 2022 08:30:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94FD6C433C1;
        Tue, 23 Aug 2022 08:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243435;
        bh=GeThJzFrqkRHTkXVI2SvRYQqWDZBlcG4+458WQ8cWxY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hncDgs3baYvmwJud0bd57IZ+efjGFk8HeSxa+Ab2Erxvm85WWRz1psl14zfavv5Yg
         fQaQrl0Y5XphZdEwmADZ5rBboy2EsGyNM465hvzD1/FYSDWQuqOXRBpWPe/pmgFvWb
         MFDZvHQ6YxOh2ITJVurAHelHBKabr2EojhzSCbQY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nilesh Javali <njavali@marvell.com>,
        Lee Duncan <lduncan@suse.com>,
        Mike Christie <michael.christie@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 277/365] scsi: iscsi: Fix HW conn removal use after free
Date:   Tue, 23 Aug 2022 10:02:58 +0200
Message-Id: <20220823080129.750454635@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
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

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit c577ab7ba5f3bf9062db8a58b6e89d4fe370447e ]

If qla4xxx doesn't remove the connection before the session, the iSCSI
class tries to remove the connection for it. We were doing a
iscsi_put_conn() in the iter function which is not needed and will result
in a use after free because iscsi_remove_conn() will free the connection.

Link: https://lore.kernel.org/r/20220616222738.5722-2-michael.christie@oracle.com
Tested-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Lee Duncan <lduncan@suse.com>
Reviewed-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_transport_iscsi.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 2a38cd2d24ef..02899e8849dd 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2143,8 +2143,6 @@ static int iscsi_iter_destroy_conn_fn(struct device *dev, void *data)
 		return 0;
 
 	iscsi_remove_conn(iscsi_dev_to_conn(dev));
-	iscsi_put_conn(iscsi_dev_to_conn(dev));
-
 	return 0;
 }
 
-- 
2.35.1



