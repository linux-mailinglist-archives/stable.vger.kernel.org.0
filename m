Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EF206AED64
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:04:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232200AbjCGSEA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:04:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231586AbjCGSDc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:03:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49E04A2C1A
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:56:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D483961469
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:56:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEC53C433EF;
        Tue,  7 Mar 2023 17:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211792;
        bh=Ch2GagY3l/hGH3hLwxa3GxLjMtkCKVzwc3FN0Tlq1Mo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iD/LJdSp1G6d8lwBy8TGrhfzIZD/7nJF6cBWymWAzWuo6+E2ih/d201na3L6qkiBm
         vGoi2NEbvR12WoJ1zGAiRT7zosJqzY8QiayuRLpM8NGqNh4tfbLzA0uuXftL7uoG6B
         +m8TW5tn3wDrq6AHFMWWfqY7edRb5y/6oEhul2eA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.2 0961/1001] scsi: qla2xxx: Remove unintended flag clearing
Date:   Tue,  7 Mar 2023 18:02:13 +0100
Message-Id: <20230307170103.897488093@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

commit 7e8a936a2d0f98dd6e5d05d4838affabe606cabc upstream.

FCF_ASYNC_SENT flag is used in session management. This flag is cleared in
task management path by accident.  Remove unintended flag clearing.

Fixes: 388a49959ee4 ("scsi: qla2xxx: Fix panic from use after free in qla2x00_async_tm_cmd")
Cc: stable@vger.kernel.org
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_init.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2076,7 +2076,6 @@ qla2x00_async_tm_cmd(fc_port_t *fcport,
 done_free_sp:
 	/* ref: INIT */
 	kref_put(&sp->cmd_kref, qla2x00_sp_release);
-	fcport->flags &= ~FCF_ASYNC_SENT;
 done:
 	return rval;
 }


