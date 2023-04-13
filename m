Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF1F6E094B
	for <lists+stable@lfdr.de>; Thu, 13 Apr 2023 10:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbjDMIt7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Apr 2023 04:49:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230306AbjDMItz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Apr 2023 04:49:55 -0400
X-Greylist: delayed 428 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 13 Apr 2023 01:49:53 PDT
Received: from gofer.mess.org (gofer.mess.org [88.97.38.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CDC386A8;
        Thu, 13 Apr 2023 01:49:53 -0700 (PDT)
Received: by gofer.mess.org (Postfix, from userid 1000)
        id 7771010006C; Thu, 13 Apr 2023 09:42:44 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mess.org; s=2020;
        t=1681375364; bh=dWFaTBn76v8qs1jmAT0tyTp0lKdEB5L7C9K57ylBhE8=;
        h=From:To:Cc:Subject:Date:From;
        b=YIBZUE0q07uXRNOAHMsLL9aAFr1TB5962vY2tC8vNxfDqJdInl0Zu4ri7cfte0pKD
         an0mvxxAIzQWoUYr4ER6/DHGwSQ9ruoME98rRyQ5UhMv6NjyliaCGZ7hSDAOW3ciFi
         L9zn/QIY3MUn3TrJ7SYiiaH4MuaNHu0flfijGrwtjoUHy1mmcKxXLmRR/Ojt5vsqiU
         hKaCqd8PfFdazfKj2+aY7I4/IN82jpeyPdGVCMDnxloLeBwZMkWBN0KfQOiKIADYuc
         oqW9MPT8XWkv/5+scIURtT7j/z4lpI/APn58levzxySJd2lVm42vtLqfclXkBHrC2v
         PGLBdwcRzLC3A==
From:   Sean Young <sean@mess.org>
To:     linux-media@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH] media: rc: bpf attach/detach requires write permission
Date:   Thu, 13 Apr 2023 09:42:44 +0100
Message-Id: <20230413084244.709562-1-sean@mess.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Note that bpf attach/detach also requires CAP_NET_ADMIN.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/bpf-lirc.c     | 6 +++---
 drivers/media/rc/lirc_dev.c     | 5 ++++-
 drivers/media/rc/rc-core-priv.h | 2 +-
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/media/rc/bpf-lirc.c b/drivers/media/rc/bpf-lirc.c
index fe17c7f98e81..52d82cbe7685 100644
--- a/drivers/media/rc/bpf-lirc.c
+++ b/drivers/media/rc/bpf-lirc.c
@@ -253,7 +253,7 @@ int lirc_prog_attach(const union bpf_attr *attr, struct bpf_prog *prog)
 	if (attr->attach_flags)
 		return -EINVAL;
 
-	rcdev = rc_dev_get_from_fd(attr->target_fd);
+	rcdev = rc_dev_get_from_fd(attr->target_fd, true);
 	if (IS_ERR(rcdev))
 		return PTR_ERR(rcdev);
 
@@ -278,7 +278,7 @@ int lirc_prog_detach(const union bpf_attr *attr)
 	if (IS_ERR(prog))
 		return PTR_ERR(prog);
 
-	rcdev = rc_dev_get_from_fd(attr->target_fd);
+	rcdev = rc_dev_get_from_fd(attr->target_fd, true);
 	if (IS_ERR(rcdev)) {
 		bpf_prog_put(prog);
 		return PTR_ERR(rcdev);
@@ -303,7 +303,7 @@ int lirc_prog_query(const union bpf_attr *attr, union bpf_attr __user *uattr)
 	if (attr->query.query_flags)
 		return -EINVAL;
 
-	rcdev = rc_dev_get_from_fd(attr->query.target_fd);
+	rcdev = rc_dev_get_from_fd(attr->query.target_fd, false);
 	if (IS_ERR(rcdev))
 		return PTR_ERR(rcdev);
 
diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 25ab61dae126..b4645e8484d1 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -810,7 +810,7 @@ void __exit lirc_dev_exit(void)
 	unregister_chrdev_region(lirc_base_dev, RC_DEV_MAX);
 }
 
-struct rc_dev *rc_dev_get_from_fd(int fd)
+struct rc_dev *rc_dev_get_from_fd(int fd, bool write)
 {
 	struct fd f = fdget(fd);
 	struct lirc_fh *fh;
@@ -824,6 +824,9 @@ struct rc_dev *rc_dev_get_from_fd(int fd)
 		return ERR_PTR(-EINVAL);
 	}
 
+	if (write && !(f.file->mode & FMODE_WRITE))
+		return ERR_PTR(-EPERM);
+
 	fh = f.file->private_data;
 	dev = fh->rc;
 
diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index ef1e95e1af7f..7df949fc65e2 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -325,7 +325,7 @@ void lirc_raw_event(struct rc_dev *dev, struct ir_raw_event ev);
 void lirc_scancode_event(struct rc_dev *dev, struct lirc_scancode *lsc);
 int lirc_register(struct rc_dev *dev);
 void lirc_unregister(struct rc_dev *dev);
-struct rc_dev *rc_dev_get_from_fd(int fd);
+struct rc_dev *rc_dev_get_from_fd(int fd, bool write);
 #else
 static inline int lirc_dev_init(void) { return 0; }
 static inline void lirc_dev_exit(void) {}
-- 
2.39.2

