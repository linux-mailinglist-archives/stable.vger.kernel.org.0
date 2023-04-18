Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E0736E64D6
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232093AbjDRMxA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:53:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232193AbjDRMw7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:52:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 157D516F89
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:52:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 12B7963440
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:52:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21E75C433EF;
        Tue, 18 Apr 2023 12:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681822333;
        bh=1PTmcP2+6LuJsrULf4ZIc+pv2aA7YcGzRwoLHFAWLGU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T8G+ljkIE7h+6ADFW9mHy2pqibU2EHhwlvPO5TylQ8/sOt+rkkpOj5RI6dfYskrTS
         d+3x+wKUntmpjIef7VqnPMRemLKWXYnjIp/FHcSBaiDuiH6/oX7Zqmgbt6Zrb30xL/
         5zuoL+wYr+V9oBBX7MaIGuc/Smgcd4mwwFG1GrEo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Michal Kolar <mich.k@seznam.cz>,
        Jiri Kosina <jkosina@suse.cz>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ding Hui <dinghui@sangfor.com.cn>
Subject: [PATCH 6.2 111/139] scsi: ses: Handle enclosure with just a primary component gracefully
Date:   Tue, 18 Apr 2023 14:22:56 +0200
Message-Id: <20230418120317.941276260@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>

commit c8e22b7a1694bb8d025ea636816472739d859145 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/ses.c |   20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -503,9 +503,6 @@ static int ses_enclosure_find_by_addr(st
 	int i;
 	struct ses_component *scomp;
 
-	if (!edev->component[0].scratch)
-		return 0;
-
 	for (i = 0; i < edev->components; i++) {
 		scomp = edev->component[i].scratch;
 		if (scomp->addr != efd->addr)
@@ -596,8 +593,10 @@ static void ses_enclosure_data_process(s
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
@@ -728,11 +727,6 @@ static int ses_intf_add(struct device *c
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
@@ -774,9 +768,11 @@ static int ses_intf_add(struct device *c
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


