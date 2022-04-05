Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AECF4F2C40
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343546AbiDEI5A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:57:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240236AbiDEIbs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:31:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27988101F7;
        Tue,  5 Apr 2022 01:23:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E7CB2B81BCE;
        Tue,  5 Apr 2022 08:23:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C94CC385C4;
        Tue,  5 Apr 2022 08:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147015;
        bh=BBrYdWG++MCLrSKzmXHsgOOi+WKZDpUEzM+K/Ckpuzk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PkCzIuP4sYMtMQmiX2iFqiD7ulVI5KKFuBhnd/qvO7ewpGCFNg2XsXf/e6uS0jBnr
         hwXb0e5ATk2ntXgVZVuDujj5uhS7qKSJEcmAkZjgdtRoFO0IRp1GvBfDx8zpgtet5u
         CiBbdfYv1g47UzT3Yf+mB6O8A9+2vlYm0DlY70Qk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.17 0972/1126] scsi: qla2xxx: Fix stuck session in gpdb
Date:   Tue,  5 Apr 2022 09:28:39 +0200
Message-Id: <20220405070436.032980844@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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
@@ -1332,9 +1332,9 @@ int qla24xx_async_gpdb(struct scsi_qla_h
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


