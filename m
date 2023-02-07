Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65EBA68D778
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:00:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbjBGNAA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:00:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231828AbjBGM7w (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 07:59:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9410439B92
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 04:59:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 07A3661407
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 12:59:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 065FCC4339B;
        Tue,  7 Feb 2023 12:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675774790;
        bh=pJFaWIrjJ0FdhcAB0IL0KRrRhR7x39EfMXX4m47ubyw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LLuppKESxQXS34TOcY/dZCoIvcWZ/znD0XKY+9XP3XxGAfrd9q75nQCvSFQaOYxCb
         eD+/eM6XXMW/SE4Q8xrbj9/DbI1PgqFTIpqTW2yot4SpFZ046dA8+LCLMP36r1Hcbh
         Ui/gcxFDMBC8cPwqS+6cH9uqUX8fPx+f9C2ntAXM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 035/208] fix iov_iter_bvec() "direction" argument
Date:   Tue,  7 Feb 2023 13:54:49 +0100
Message-Id: <20230207125635.910189543@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit b676668d99155e6859d99bbf2df18b3f03851902 ]

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Stable-dep-of: 6dd88fd59da8 ("vhost-scsi: unbreak any layout for response")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_file.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 28aa643be5d5..55935040541b 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -337,7 +337,7 @@ static int fd_do_rw(struct se_cmd *cmd, struct file *fd,
 		len += sg->length;
 	}
 
-	iov_iter_bvec(&iter, READ, bvec, sgl_nents, len);
+	iov_iter_bvec(&iter, is_write, bvec, sgl_nents, len);
 	if (is_write)
 		ret = vfs_iter_write(fd, &iter, &pos, 0);
 	else
@@ -473,7 +473,7 @@ fd_execute_write_same(struct se_cmd *cmd)
 		len += se_dev->dev_attrib.block_size;
 	}
 
-	iov_iter_bvec(&iter, READ, bvec, nolb, len);
+	iov_iter_bvec(&iter, WRITE, bvec, nolb, len);
 	ret = vfs_iter_write(fd_dev->fd_file, &iter, &pos, 0);
 
 	kfree(bvec);
-- 
2.39.0



