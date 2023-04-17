Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAFE06E41DD
	for <lists+stable@lfdr.de>; Mon, 17 Apr 2023 10:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbjDQIBK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Apr 2023 04:01:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbjDQIAv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Apr 2023 04:00:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6003E49F2
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 01:00:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB0F061059
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 08:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8D01C4339B;
        Mon, 17 Apr 2023 08:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681718411;
        bh=9mfLPF+RA+fi/qBKb5MNlZ3CZ9pm5xhQCQiavBb0Ad4=;
        h=Subject:To:Cc:From:Date:From;
        b=NPXwNopKmXXauY83ZhU3q7/CkLxBWOspfpo8POgDHqkhUpVsIxbOFKDUUjn5OSXUn
         sslxgoRgohRvYMcDN04+UcZSph2IRjU9e90HR8biVK8yWjCYVG0h2PiJ3muXtrggrq
         Ph44BSySVPy/WAbS6EUxb55s4YrjMwpjchdUm2Yw=
Subject: FAILED: patch "[PATCH] scsi: ses: Handle enclosure with just a primary component" failed to apply to 4.14-stable tree
To:     jkosina@suse.cz, dinghui@sangfor.com.cn,
        martin.petersen@oracle.com, mich.k@seznam.cz
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 Apr 2023 10:00:05 +0200
Message-ID: <2023041705-wages-cabbage-66be@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-4.14.y
git checkout FETCH_HEAD
git cherry-pick -x c8e22b7a1694bb8d025ea636816472739d859145
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '2023041705-wages-cabbage-66be@gregkh' --subject-prefix 'PATCH 4.14.y' HEAD^..

Possible dependencies:

c8e22b7a1694 ("scsi: ses: Handle enclosure with just a primary component gracefully")
3fe97ff3d949 ("scsi: ses: Don't attach if enclosure has no components")
6396bb221514 ("treewide: kzalloc() -> kcalloc()")
5f85942c2ea2 ("Merge tag 'scsi-misc' of git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c8e22b7a1694bb8d025ea636816472739d859145 Mon Sep 17 00:00:00 2001
From: Jiri Kosina <jkosina@suse.cz>
Date: Tue, 4 Apr 2023 21:23:42 +0200
Subject: [PATCH] scsi: ses: Handle enclosure with just a primary component
 gracefully

This reverts commit 3fe97ff3d949 ("scsi: ses: Don't attach if enclosure
has no components") and introduces proper handling of case where there are
no detected secondary components, but primary component (enumerated in
num_enclosures) does exist. That fix was originally proposed by Ding Hui
<dinghui@sangfor.com.cn>.

Completely ignoring devices that have one primary enclosure and no
secondary one results in ses_intf_add() bailing completely

	scsi 2:0:0:254: enclosure has no enumerated components
        scsi 2:0:0:254: Failed to bind enclosure -12ven in valid configurations such

even on valid configurations with 1 primary and 0 secondary enclosures as
below:

	# sg_ses /dev/sg0
	  3PARdata  SES               3321
	Supported diagnostic pages:
	  Supported Diagnostic Pages [sdp] [0x0]
	  Configuration (SES) [cf] [0x1]
	  Short Enclosure Status (SES) [ses] [0x8]
	# sg_ses -p cf /dev/sg0
	  3PARdata  SES               3321
	Configuration diagnostic page:
	  number of secondary subenclosures: 0
	  generation code: 0x0
	  enclosure descriptor list
	    Subenclosure identifier: 0 [primary]
	      relative ES process id: 0, number of ES processes: 1
	      number of type descriptor headers: 1
	      enclosure logical identifier (hex): 20000002ac02068d
	      enclosure vendor: 3PARdata  product: VV                rev: 3321
	  type descriptor header and text list
	    Element type: Unspecified, subenclosure id: 0
	      number of possible elements: 1

The changelog for the original fix follows

=====
We can get a crash when disconnecting the iSCSI session,
the call trace like this:

  [ffff00002a00fb70] kfree at ffff00000830e224
  [ffff00002a00fba0] ses_intf_remove at ffff000001f200e4
  [ffff00002a00fbd0] device_del at ffff0000086b6a98
  [ffff00002a00fc50] device_unregister at ffff0000086b6d58
  [ffff00002a00fc70] __scsi_remove_device at ffff00000870608c
  [ffff00002a00fca0] scsi_remove_device at ffff000008706134
  [ffff00002a00fcc0] __scsi_remove_target at ffff0000087062e4
  [ffff00002a00fd10] scsi_remove_target at ffff0000087064c0
  [ffff00002a00fd70] __iscsi_unbind_session at ffff000001c872c4
  [ffff00002a00fdb0] process_one_work at ffff00000810f35c
  [ffff00002a00fe00] worker_thread at ffff00000810f648
  [ffff00002a00fe70] kthread at ffff000008116e98

In ses_intf_add, components count could be 0, and kcalloc 0 size scomp,
but not saved in edev->component[i].scratch

In this situation, edev->component[0].scratch is an invalid pointer,
when kfree it in ses_intf_remove_enclosure, a crash like above would happen
The call trace also could be other random cases when kfree cannot catch
the invalid pointer

We should not use edev->component[] array when the components count is 0
We also need check index when use edev->component[] array in
ses_enclosure_data_process
=====

Reported-by: Michal Kolar <mich.k@seznam.cz>
Originally-by: Ding Hui <dinghui@sangfor.com.cn>
Cc: stable@vger.kernel.org
Fixes: 3fe97ff3d949 ("scsi: ses: Don't attach if enclosure has no components")
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Link: https://lore.kernel.org/r/nycvar.YFH.7.76.2304042122270.29760@cbobk.fhfr.pm
Tested-by: Michal Kolar <mich.k@seznam.cz>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index b11a9162e73a..b54f2c6c08c3 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -509,9 +509,6 @@ static int ses_enclosure_find_by_addr(struct enclosure_device *edev,
 	int i;
 	struct ses_component *scomp;
 
-	if (!edev->component[0].scratch)
-		return 0;
-
 	for (i = 0; i < edev->components; i++) {
 		scomp = edev->component[i].scratch;
 		if (scomp->addr != efd->addr)
@@ -602,8 +599,10 @@ static void ses_enclosure_data_process(struct enclosure_device *edev,
 						components++,
 						type_ptr[0],
 						name);
-				else
+				else if (components < edev->components)
 					ecomp = &edev->component[components++];
+				else
+					ecomp = ERR_PTR(-EINVAL);
 
 				if (!IS_ERR(ecomp)) {
 					if (addl_desc_ptr) {
@@ -734,11 +733,6 @@ static int ses_intf_add(struct device *cdev,
 			components += type_ptr[1];
 	}
 
-	if (components == 0) {
-		sdev_printk(KERN_WARNING, sdev, "enclosure has no enumerated components\n");
-		goto err_free;
-	}
-
 	ses_dev->page1 = buf;
 	ses_dev->page1_len = len;
 	buf = NULL;
@@ -780,9 +774,11 @@ static int ses_intf_add(struct device *cdev,
 		buf = NULL;
 	}
 page2_not_supported:
-	scomp = kcalloc(components, sizeof(struct ses_component), GFP_KERNEL);
-	if (!scomp)
-		goto err_free;
+	if (components > 0) {
+		scomp = kcalloc(components, sizeof(struct ses_component), GFP_KERNEL);
+		if (!scomp)
+			goto err_free;
+	}
 
 	edev = enclosure_register(cdev->parent, dev_name(&sdev->sdev_gendev),
 				  components, &ses_enclosure_callbacks);

