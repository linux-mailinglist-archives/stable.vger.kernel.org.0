Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8A7D59E557
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 16:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239989AbiHWOt5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 10:49:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240407AbiHWOtF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 10:49:05 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C113797B21;
        Tue, 23 Aug 2022 05:12:03 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id r83-20020a1c4456000000b003a5cb389944so9446608wma.4;
        Tue, 23 Aug 2022 05:12:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=Sow7EIgFIOPe6XEmV+aS5N5loSVChyRYxntO1B69FSs=;
        b=Ky8649mVE+WHzwqepaqT2FgpL0wDvjUR3zZFJPYgGbr4jIbE0rIAQeHfHhSNPKKz25
         mneeC29stBXPCdO84HZEw+/nFiZTIQEJrYo7objtWSjDkjYcl+VxXRmrovOniIhXnNe2
         s3HREC7+Nc+/Ra/3SA/5nLVg3gzQblL0kmiYg6OGbtu85HdyHWLRDYwvCs2Y6mra+bF9
         5xGtI2UtwBCjbuGyIK9w3aJeaiThVWCnRNrvLnKgWl/YFixItO1gcbHdEWSr+l9sxAW1
         yKC6Q5WSAVMod3SrSgiVWzsxP5/Rrbo0ZlJfsCB5Y0CATN8hwGF6DW7ksTGk0u+NeChs
         CnYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=Sow7EIgFIOPe6XEmV+aS5N5loSVChyRYxntO1B69FSs=;
        b=mU0N17G2sjobCFgO2KrxBbFc0trsCwWwIoYPh5GxhorZQHstj7ck7SaatRbYR5KOMv
         lofXWmvVP4J0aQnKmEgCJXTSU4D9m1vkNcv2RN/s+UPqXnuLskY/T2ExD+SOBoE11is4
         JySLid3gQWBwrrwUM9zXvwGJZar0/w1Ck8PVynkQ7oC5dy+QR+2SzORyBv6ElcxF8i/u
         DjDuoL95hy2Wh44s4itvbWV+NQNt8wjOsgstF0aVELuCygV6F+k4yy/kwzt/h+C7KO0r
         JSQLYwukGAwiOQTShQoOn/8+cWqCDXD5sET2XoewOnrmQmVPks5GHgVtQG7VdYMzDtun
         djpA==
X-Gm-Message-State: ACgBeo378UwbqX+X2sEVdmzPkgy/ne2AD3hysaCG8kScGu/o7cSNKlFD
        7N7xBkWgEmya/2Ju4KoTu5DYadFliHU=
X-Google-Smtp-Source: AA6agR7oAH/cSRHFfc4FSK2qKs7uJVSinXKvXhgxBHNr1phYKGTWcmQlGdzio6TXvzTMrLjIOor41w==
X-Received: by 2002:a7b:cb9a:0:b0:3a6:632d:5ee8 with SMTP id m26-20020a7bcb9a000000b003a6632d5ee8mr1944457wmi.175.1661256703534;
        Tue, 23 Aug 2022 05:11:43 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([77.137.66.49])
        by smtp.gmail.com with ESMTPSA id g11-20020a05600c4ecb00b003a4c6e67f01sm24681879wmq.6.2022.08.23.05.11.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 05:11:43 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 5.10 v2 1/6] xfs: prevent a WARN_ONCE() in xfs_ioc_attr_list()
Date:   Tue, 23 Aug 2022 15:11:31 +0300
Message-Id: <20220823121136.1806820-2-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220823121136.1806820-1-amir73il@gmail.com>
References: <20220823121136.1806820-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 6ed6356b07714e0198be3bc3ecccc8b40a212de4 upstream.

The "bufsize" comes from the root user.  If "bufsize" is negative then,
because of type promotion, neither of the validation checks at the start
of the function are able to catch it:

	if (bufsize < sizeof(struct xfs_attrlist) ||
	    bufsize > XFS_XATTR_LIST_MAX)
		return -EINVAL;

This means "bufsize" will trigger (WARN_ON_ONCE(size > INT_MAX)) in
kvmalloc_node().  Fix this by changing the type from int to size_t.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_ioctl.c | 2 +-
 fs/xfs/xfs_ioctl.h | 5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 646735aad45d..d973350d5946 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -371,7 +371,7 @@ int
 xfs_ioc_attr_list(
 	struct xfs_inode		*dp,
 	void __user			*ubuf,
-	int				bufsize,
+	size_t				bufsize,
 	int				flags,
 	struct xfs_attrlist_cursor __user *ucursor)
 {
diff --git a/fs/xfs/xfs_ioctl.h b/fs/xfs/xfs_ioctl.h
index bab6a5a92407..416e20de66e7 100644
--- a/fs/xfs/xfs_ioctl.h
+++ b/fs/xfs/xfs_ioctl.h
@@ -38,8 +38,9 @@ xfs_readlink_by_handle(
 int xfs_ioc_attrmulti_one(struct file *parfilp, struct inode *inode,
 		uint32_t opcode, void __user *uname, void __user *value,
 		uint32_t *len, uint32_t flags);
-int xfs_ioc_attr_list(struct xfs_inode *dp, void __user *ubuf, int bufsize,
-	int flags, struct xfs_attrlist_cursor __user *ucursor);
+int xfs_ioc_attr_list(struct xfs_inode *dp, void __user *ubuf,
+		      size_t bufsize, int flags,
+		      struct xfs_attrlist_cursor __user *ucursor);
 
 extern struct dentry *
 xfs_handle_to_dentry(
-- 
2.25.1

