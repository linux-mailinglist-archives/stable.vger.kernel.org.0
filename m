Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4BE5580FF
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 18:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233235AbiFWQyz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 12:54:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233683AbiFWQx1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:53:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85C7631348;
        Thu, 23 Jun 2022 09:52:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF33961F90;
        Thu, 23 Jun 2022 16:52:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99190C3411B;
        Thu, 23 Jun 2022 16:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003165;
        bh=7a3X5S4EWiiyoZ0hOPsEVtuYVA4mAKzC4VUCZXEauq4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w5gsUQ5QpaO5QouJDP0KC/GZN14GIl6A7N53IKwbsQxF2nDOh5+/9eGUFfBM8MBPf
         CLYngooGRReg+fs7N9gpzC9KeXq4q/ugJkv5dFbKcJx2+86QVGymfZpNpADclQNPZK
         yo4aTce+LdyyTgdcgDRtLrzSf/HaBovAfcg/ZBek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Harald Freudenberger <freude@linux.vnet.ibm.com>,
        PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.9 151/264] hwrng: remember rng chosen by user
Date:   Thu, 23 Jun 2022 18:42:24 +0200
Message-Id: <20220623164348.337124189@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164344.053938039@linuxfoundation.org>
References: <20220623164344.053938039@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harald Freudenberger <freude@linux.vnet.ibm.com>

commit 10a515ddb5f19a1ff0b9882c430b4427843169f3 upstream.

When a user chooses a rng source via sysfs attribute
this rng should be sticky, even when other sources
with better quality to register. This patch introduces
a simple way to remember the user's choice. This is
reflected by a new sysfs attribute file 'rng_selected'
which shows if the current rng has been chosen by
userspace. The new attribute file shows '1' for user
selected rng and '0' otherwise.

Signed-off-by: Harald Freudenberger <freude@linux.vnet.ibm.com>
Reviewed-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/hw_random/core.c |   21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -27,6 +27,8 @@
 #define RNG_MODULE_NAME		"hw_random"
 
 static struct hwrng *current_rng;
+/* the current rng has been explicitly chosen by user via sysfs */
+static int cur_rng_set_by_user;
 static struct task_struct *hwrng_fill;
 /* list of registered rngs, sorted decending by quality */
 static LIST_HEAD(rng_list);
@@ -303,6 +305,7 @@ static ssize_t hwrng_attr_current_store(
 	list_for_each_entry(rng, &rng_list, list) {
 		if (sysfs_streq(rng->name, buf)) {
 			err = 0;
+			cur_rng_set_by_user = 1;
 			if (rng != current_rng)
 				err = set_current_rng(rng);
 			break;
@@ -351,16 +354,27 @@ static ssize_t hwrng_attr_available_show
 	return strlen(buf);
 }
 
+static ssize_t hwrng_attr_selected_show(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%d\n", cur_rng_set_by_user);
+}
+
 static DEVICE_ATTR(rng_current, S_IRUGO | S_IWUSR,
 		   hwrng_attr_current_show,
 		   hwrng_attr_current_store);
 static DEVICE_ATTR(rng_available, S_IRUGO,
 		   hwrng_attr_available_show,
 		   NULL);
+static DEVICE_ATTR(rng_selected, S_IRUGO,
+		   hwrng_attr_selected_show,
+		   NULL);
 
 static struct attribute *rng_dev_attrs[] = {
 	&dev_attr_rng_current.attr,
 	&dev_attr_rng_available.attr,
+	&dev_attr_rng_selected.attr,
 	NULL
 };
 
@@ -443,10 +457,12 @@ int hwrng_register(struct hwrng *rng)
 
 	old_rng = current_rng;
 	err = 0;
-	if (!old_rng || (rng->quality > old_rng->quality)) {
+	if (!old_rng ||
+	    (!cur_rng_set_by_user && rng->quality > old_rng->quality)) {
 		/*
 		 * Set new rng as current as the new rng source
-		 * provides better entropy quality.
+		 * provides better entropy quality and was not
+		 * chosen by userspace.
 		 */
 		err = set_current_rng(rng);
 		if (err)
@@ -478,6 +494,7 @@ void hwrng_unregister(struct hwrng *rng)
 	list_del(&rng->list);
 	if (current_rng == rng) {
 		drop_current_rng();
+		cur_rng_set_by_user = 0;
 		/* rng_list is sorted by quality, use the best (=first) one */
 		if (!list_empty(&rng_list)) {
 			struct hwrng *new_rng;


