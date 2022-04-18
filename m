Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DEB9504FE1
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238113AbiDRMSv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:18:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238104AbiDRMSP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:18:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D523A1A066;
        Mon, 18 Apr 2022 05:15:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 62B7860F1A;
        Mon, 18 Apr 2022 12:15:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E2A8C385A7;
        Mon, 18 Apr 2022 12:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284132;
        bh=hnXxtEBUA5ZxcilPT0tseZET3rfXT3b/XiaIGhqWjCs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PbF72GmOHA81fne+hITSEE7twNljrgi1TUzF9wgpgTcN23Gw/+7jlCDMdtVDlADba
         4zwAPZLxeyUTeDIAOhwlNGNUepGPrW6KCfp122cK5YWzRoM9jRI1pDFZZ8KDmrv7QH
         W7/kKPWW96gXDXGqonqObEyiYbI0P4ucYJNO+kv4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.17 017/219] ALSA: core: Add snd_card_free_on_error() helper
Date:   Mon, 18 Apr 2022 14:09:46 +0200
Message-Id: <20220418121204.214119268@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
References: <20220418121203.462784814@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

commit fee2b871d8d6389c9b4bdf9346a99ccc1c98c9b8 upstream.

This is a small helper function to handle the error path more easily
when an error happens during the probe for the device with the
device-managed card.  Since devres releases in the reverser order of
the creations, usually snd_card_free() gets called at the last in the
probe error path unless it already reached snd_card_register() calls.
Due to this nature, when a driver expects the resource releases in
card->private_free, this might be called too lately.

As a workaround, one should call the probe like:

 static int __some_probe(...) { // do real probe.... }

 static int some_probe(...)
 {
	return snd_card_free_on_error(dev, __some_probe(dev, ...));
 }

so that the snd_card_free() is called explicitly at the beginning of
the error path from the probe.

This function will be used in the upcoming fixes to address the
regressions by devres usages.

Fixes: e8ad415b7a55 ("ALSA: core: Add managed card creation")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220412093141.8008-2-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/sound/core.h |    1 +
 sound/core/init.c    |   28 ++++++++++++++++++++++++++++
 2 files changed, 29 insertions(+)

--- a/include/sound/core.h
+++ b/include/sound/core.h
@@ -284,6 +284,7 @@ int snd_card_disconnect(struct snd_card
 void snd_card_disconnect_sync(struct snd_card *card);
 int snd_card_free(struct snd_card *card);
 int snd_card_free_when_closed(struct snd_card *card);
+int snd_card_free_on_error(struct device *dev, int ret);
 void snd_card_set_id(struct snd_card *card, const char *id);
 int snd_card_register(struct snd_card *card);
 int snd_card_info_init(void);
--- a/sound/core/init.c
+++ b/sound/core/init.c
@@ -209,6 +209,12 @@ static void __snd_card_release(struct de
  * snd_card_register(), the very first devres action to call snd_card_free()
  * is added automatically.  In that way, the resource disconnection is assured
  * at first, then released in the expected order.
+ *
+ * If an error happens at the probe before snd_card_register() is called and
+ * there have been other devres resources, you'd need to free the card manually
+ * via snd_card_free() call in the error; otherwise it may lead to UAF due to
+ * devres call orders.  You can use snd_card_free_on_error() helper for
+ * handling it more easily.
  */
 int snd_devm_card_new(struct device *parent, int idx, const char *xid,
 		      struct module *module, size_t extra_size,
@@ -235,6 +241,28 @@ int snd_devm_card_new(struct device *par
 }
 EXPORT_SYMBOL_GPL(snd_devm_card_new);
 
+/**
+ * snd_card_free_on_error - a small helper for handling devm probe errors
+ * @dev: the managed device object
+ * @ret: the return code from the probe callback
+ *
+ * This function handles the explicit snd_card_free() call at the error from
+ * the probe callback.  It's just a small helper for simplifying the error
+ * handling with the managed devices.
+ */
+int snd_card_free_on_error(struct device *dev, int ret)
+{
+	struct snd_card *card;
+
+	if (!ret)
+		return 0;
+	card = devres_find(dev, __snd_card_release, NULL, NULL);
+	if (card)
+		snd_card_free(card);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(snd_card_free_on_error);
+
 static int snd_card_init(struct snd_card *card, struct device *parent,
 			 int idx, const char *xid, struct module *module,
 			 size_t extra_size)


