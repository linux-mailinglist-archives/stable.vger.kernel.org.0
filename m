Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E89FE19C955
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:03:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389297AbgDBTDW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:03:22 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:34371 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388843AbgDBTDW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:03:22 -0400
Received: by mail-wm1-f68.google.com with SMTP id c195so316226wme.1
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:03:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Xqfqaao4MLLH+J6dNDM8nik5DOhFY8K5BbIRbAOhXY4=;
        b=uPKLoH8rCamTkls3Qh7rB/N+6FIZ8E7X6N8oYyaHgYG+xdbu0e5aNyb2yA4meGLZ2n
         fveyoMrTi5v84FEBd8QSqYtXHSODVsc4KYS6uXKJm3oXUOEBdTPhO637vYDe/KODJ5ke
         Bq+lzppuAP9TB8ajiSCEyXt2majhx7X+ELl+UG8ELqJem/KO1Uh1rkX0YnUdUlr38pOI
         XBuZxgjPI63muISSzTVgVqFnYqF8K7v+TumuMURAU4HBFcIH0aPHfvfcYDTFF6KMCTHR
         dXZaOy+mYKye7zXWGhhA8ONkNBEihBiXQvLfKmgu2I6bzyCpNNkjSJeSWnCWWzvLcFUJ
         FQNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Xqfqaao4MLLH+J6dNDM8nik5DOhFY8K5BbIRbAOhXY4=;
        b=JbaRqfQS7Fofekr4JE8dGKozkiq8agFUT/n9WI8fQlFRw3Nt9I8cqAb6a3BU0DKGYr
         l6oq+R3dJ9G9kkjEUobLUwo+HNGkmKsvcFAFUAc7P5KVkSMrt6TURUOrbq7EAtRPTxtR
         uTuapiwVoS1gQQ7aJ5Nj7GzBYvuhfPVfLF2OCjs27VYOTsNTebl1tzGimA40a4GAErS7
         JDQeGly5YNwlgzAtI9UWNnnRVhLg1bV61mU0vY2TlvSvW+uEZYjgCjTY6E4fWtKELrWG
         7j2HYKEfnLDzwZVkuTMm35fZjGhfisiPmGSAg4oQeopQ7+cvnY52KOekKFDP6sYyPksu
         61rA==
X-Gm-Message-State: AGi0PuY6ZmCCE7gvwB5rcGU/Cbv/RrfzVugXej91rTyz39itRHWptQ6A
        syvoK8m+it4LzvZEqlasbic=
X-Google-Smtp-Source: APiQypL2bysbkxyRiwXuddkacIKGHko4KuT2q4sEcBZ1mPMxhjYpzIJRB2WNikNLqb2WWs8u4Ly1rw==
X-Received: by 2002:a1c:4b19:: with SMTP id y25mr4713388wma.70.1585854199976;
        Thu, 02 Apr 2020 12:03:19 -0700 (PDT)
Received: from localhost.localdomain.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id n2sm8905315wro.25.2020.04.02.12.03.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 Apr 2020 12:03:19 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-nvme@lists.infradead.org
Cc:     James Smart <jsmart2021@gmail.com>, stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>
Subject: [PATCH] nvme-fc: revert controller references on lldd module
Date:   Thu,  2 Apr 2020 12:03:12 -0700
Message-Id: <20200402190312.88868-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.16.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch partially reverts the commit for
  nvme_fc: add module to ops template to allow module references

The original patch:
  Added an ops parameter of "module" to be set by the lldd, and the
    lldds were updated to provide their value.
  Used the parameter to take module references when a controller was
    created or terminated.

The original patch was to resolve the lldd being able to be unloaded
while being used to talk to the boot device of the system. However, the
end result of the original patch is that any driver unload while a nvme
controller is live via the lldd is not being prohibited. Given the module
reference, the module teardown routine can't be called, thus there's no
way, other than manual actions to terminate the controllers.

This patch reverts the portion of the patch that takes module references
on controller creation. It leaves the module parameter so that it could
be used in the future.

As such, there will still remain the issue of detaching from the boot
device, yet needing boot device access to load a new module to replace
the lldd that was unloaded. A solution will be looked for later.

-- james

Fixes: 863fbae929c7 ("nvme_fc: add module to ops template to allow module  references")
Cc: <stable@vger.kernel.org> # v5.4+
Signed-off-by: James Smart <jsmart2021@gmail.com>
Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
CC: Christoph Hellwig <hch@lst.de>
CC: Keith Busch <kbusch@kernel.org>
---
 drivers/nvme/host/fc.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
index a8bf2fb1287b..1419c8c41fd8 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -2016,7 +2016,6 @@ nvme_fc_ctrl_free(struct kref *ref)
 {
 	struct nvme_fc_ctrl *ctrl =
 		container_of(ref, struct nvme_fc_ctrl, ref);
-	struct nvme_fc_lport *lport = ctrl->lport;
 	unsigned long flags;
 
 	if (ctrl->ctrl.tagset) {
@@ -2043,7 +2042,6 @@ nvme_fc_ctrl_free(struct kref *ref)
 	if (ctrl->ctrl.opts)
 		nvmf_free_options(ctrl->ctrl.opts);
 	kfree(ctrl);
-	module_put(lport->ops->module);
 }
 
 static void
@@ -3074,15 +3072,10 @@ nvme_fc_init_ctrl(struct device *dev, struct nvmf_ctrl_options *opts,
 		goto out_fail;
 	}
 
-	if (!try_module_get(lport->ops->module)) {
-		ret = -EUNATCH;
-		goto out_free_ctrl;
-	}
-
 	idx = ida_simple_get(&nvme_fc_ctrl_cnt, 0, 0, GFP_KERNEL);
 	if (idx < 0) {
 		ret = -ENOSPC;
-		goto out_mod_put;
+		goto out_free_ctrl;
 	}
 
 	ctrl->ctrl.opts = opts;
@@ -3232,8 +3225,6 @@ nvme_fc_init_ctrl(struct device *dev, struct nvmf_ctrl_options *opts,
 out_free_ida:
 	put_device(ctrl->dev);
 	ida_simple_remove(&nvme_fc_ctrl_cnt, ctrl->cnum);
-out_mod_put:
-	module_put(lport->ops->module);
 out_free_ctrl:
 	kfree(ctrl);
 out_fail:
-- 
2.16.4

