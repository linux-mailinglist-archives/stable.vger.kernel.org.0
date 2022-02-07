Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 087BE4ABAB1
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:30:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384003AbiBGLYY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:24:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237205AbiBGLLF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:11:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 477D4C0401C1;
        Mon,  7 Feb 2022 03:11:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0DF45B811A6;
        Mon,  7 Feb 2022 11:11:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52ADBC004E1;
        Mon,  7 Feb 2022 11:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232261;
        bh=HoMyJXz97HdBTqBQY7JhzI1zoEnUBX8t+3RwFnC0Vw8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AK+SvVEgQR2UDX85yhSI/3KTfNdYecWBdhwuHtCssecbQPnzlYSW0YfCh3veKS/jb
         Y/SDOtVwHzQ5CMu6CiOrt6HYzJP2Z/D5jUVvIyW+3dyPr69wHYq/sfuhHVpqlzJveG
         OWxygg3eh8EdTiwpt1emHq3LYr/nVc8uEAe7e214=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sujit Kautkar <sujitka@chromium.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <swboyd@chromium.org>
Subject: [PATCH 4.14 21/69] rpmsg: char: Fix race between the release of rpmsg_ctrldev and cdev
Date:   Mon,  7 Feb 2022 12:05:43 +0100
Message-Id: <20220207103756.312194100@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103755.604121441@linuxfoundation.org>
References: <20220207103755.604121441@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Sujit Kautkar <sujitka@chromium.org>

commit b7fb2dad571d1e21173c06cef0bced77b323990a upstream.

struct rpmsg_ctrldev contains a struct cdev. The current code frees
the rpmsg_ctrldev struct in rpmsg_ctrldev_release_device(), but the
cdev is a managed object, therefore its release is not predictable
and the rpmsg_ctrldev could be freed before the cdev is entirely
released, as in the backtrace below.

[   93.625603] ODEBUG: free active (active state 0) object type: timer_list hint: delayed_work_timer_fn+0x0/0x7c
[   93.636115] WARNING: CPU: 0 PID: 12 at lib/debugobjects.c:488 debug_print_object+0x13c/0x1b0
[   93.644799] Modules linked in: veth xt_cgroup xt_MASQUERADE rfcomm algif_hash algif_skcipher af_alg uinput ip6table_nat fuse uvcvideo videobuf2_vmalloc venus_enc venus_dec videobuf2_dma_contig hci_uart btandroid btqca snd_soc_rt5682_i2c bluetooth qcom_spmi_temp_alarm snd_soc_rt5682v
[   93.715175] CPU: 0 PID: 12 Comm: kworker/0:1 Tainted: G    B             5.4.163-lockdep #26
[   93.723855] Hardware name: Google Lazor (rev3 - 8) with LTE (DT)
[   93.730055] Workqueue: events kobject_delayed_cleanup
[   93.735271] pstate: 60c00009 (nZCv daif +PAN +UAO)
[   93.740216] pc : debug_print_object+0x13c/0x1b0
[   93.744890] lr : debug_print_object+0x13c/0x1b0
[   93.749555] sp : ffffffacf5bc7940
[   93.752978] x29: ffffffacf5bc7940 x28: dfffffd000000000
[   93.758448] x27: ffffffacdb11a800 x26: dfffffd000000000
[   93.763916] x25: ffffffd0734f856c x24: dfffffd000000000
[   93.769389] x23: 0000000000000000 x22: ffffffd0733c35b0
[   93.774860] x21: ffffffd0751994a0 x20: ffffffd075ec27c0
[   93.780338] x19: ffffffd075199100 x18: 00000000000276e0
[   93.785814] x17: 0000000000000000 x16: dfffffd000000000
[   93.791291] x15: ffffffffffffffff x14: 6e6968207473696c
[   93.796768] x13: 0000000000000000 x12: ffffffd075e2b000
[   93.802244] x11: 0000000000000001 x10: 0000000000000000
[   93.807723] x9 : d13400dff1921900 x8 : d13400dff1921900
[   93.813200] x7 : 0000000000000000 x6 : 0000000000000000
[   93.818676] x5 : 0000000000000080 x4 : 0000000000000000
[   93.824152] x3 : ffffffd0732a0fa4 x2 : 0000000000000001
[   93.829628] x1 : ffffffacf5bc7580 x0 : 0000000000000061
[   93.835104] Call trace:
[   93.837644]  debug_print_object+0x13c/0x1b0
[   93.841963]  __debug_check_no_obj_freed+0x25c/0x3c0
[   93.846987]  debug_check_no_obj_freed+0x18/0x20
[   93.851669]  slab_free_freelist_hook+0xbc/0x1e4
[   93.856346]  kfree+0xfc/0x2f4
[   93.859416]  rpmsg_ctrldev_release_device+0x78/0xb8
[   93.864445]  device_release+0x84/0x168
[   93.868310]  kobject_cleanup+0x12c/0x298
[   93.872356]  kobject_delayed_cleanup+0x10/0x18
[   93.876948]  process_one_work+0x578/0x92c
[   93.881086]  worker_thread+0x804/0xcf8
[   93.884963]  kthread+0x2a8/0x314
[   93.888303]  ret_from_fork+0x10/0x18

The cdev_device_add/del() API was created to address this issue (see
commit '233ed09d7fda ("chardev: add helper function to register char
devs with a struct device")'), use it instead of cdev add/del().

Fixes: c0cdc19f84a4 ("rpmsg: Driver for user space endpoint interface")
Signed-off-by: Sujit Kautkar <sujitka@chromium.org>
Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
Reviewed-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220110104706.v6.1.Iaac908f3e3149a89190ce006ba166e2d3fd247a3@changeid
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rpmsg/rpmsg_char.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

--- a/drivers/rpmsg/rpmsg_char.c
+++ b/drivers/rpmsg/rpmsg_char.c
@@ -461,7 +461,6 @@ static void rpmsg_ctrldev_release_device
 
 	ida_simple_remove(&rpmsg_ctrl_ida, dev->id);
 	ida_simple_remove(&rpmsg_minor_ida, MINOR(dev->devt));
-	cdev_del(&ctrldev->cdev);
 	kfree(ctrldev);
 }
 
@@ -496,19 +495,13 @@ static int rpmsg_chrdev_probe(struct rpm
 	dev->id = ret;
 	dev_set_name(&ctrldev->dev, "rpmsg_ctrl%d", ret);
 
-	ret = cdev_add(&ctrldev->cdev, dev->devt, 1);
+	ret = cdev_device_add(&ctrldev->cdev, &ctrldev->dev);
 	if (ret)
 		goto free_ctrl_ida;
 
 	/* We can now rely on the release function for cleanup */
 	dev->release = rpmsg_ctrldev_release_device;
 
-	ret = device_add(dev);
-	if (ret) {
-		dev_err(&rpdev->dev, "device_add failed: %d\n", ret);
-		put_device(dev);
-	}
-
 	dev_set_drvdata(&rpdev->dev, ctrldev);
 
 	return ret;
@@ -534,7 +527,7 @@ static void rpmsg_chrdev_remove(struct r
 	if (ret)
 		dev_warn(&rpdev->dev, "failed to nuke endpoints: %d\n", ret);
 
-	device_del(&ctrldev->dev);
+	cdev_device_del(&ctrldev->cdev, &ctrldev->dev);
 	put_device(&ctrldev->dev);
 }
 


