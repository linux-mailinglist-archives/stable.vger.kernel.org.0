Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC4FC81191
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 07:26:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725976AbfHEF0A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 01:26:00 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:43263 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726378AbfHEF0A (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Aug 2019 01:26:00 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 82A7820A34;
        Mon,  5 Aug 2019 01:25:59 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 05 Aug 2019 01:25:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=y7DYLq
        YdCCEZ6SpnPX3weYVnyxjDyiuWTbDWaL2qIXM=; b=C3T/quHN4UOyN8+qd2v9gn
        Spai98AT4Z8FO4lM59Phqbzia+99LfvVFLP6F7WL3g29NFFZRx+swoi1pLYrqJDE
        NLmJnH/7C+TfIuRuTflPoCijV6IuEAtuFdY++f6fJ5ov99IS969lWiueMg5zqrLv
        HGeOaNOan40pMzDDZun6Y9px0NamevohrFkA45dySFeM7xO6t2HW2neNMpo3fbog
        RhnY+zrTyBysVdbxy76qkrwVW6tbRMLrdPxTsJOOeolBP4wAhb+iHZyHlGs/4frK
        pLaUhm5dQ8i6ALPEVGhqVh9WUKmkuo3L6ghPjWJ0aFY+F7ld5cvkUkMQe5dUxWwQ
        ==
X-ME-Sender: <xms:571HXeoztfLZhmnlKqu-WlxWg-MQ2HjTX-LwMn1XJ0Uftq3T9zzjdQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddtiedgkeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:571HXYLplY6ZPgIsI3ETva5KrKC8BWS6dzkyS23U2MnP1cg9KtReqA>
    <xmx:571HXZpiGOsCaa01yGnuALrSe7r0XkitWlKmqGVNbjaHD__JKNxNjw>
    <xmx:571HXYwUBqkqWcCZ0mCisWhX4ifYwU2WB3GD7qwJg-7fes2rwbJYHg>
    <xmx:571HXfbdHTkh0KDkqxYNPVsl9upyGnqm6d8SbzQvM2DnCY9-_cTU3Q>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id E874E380074;
        Mon,  5 Aug 2019 01:25:58 -0400 (EDT)
Subject: FAILED: patch "[PATCH] eeprom: at24: make spd world-readable again" failed to apply to 4.14-stable tree
To:     jdelvare@suse.de, andrew@lunn.ch, arnd@arndb.de,
        bgolaszewski@baylibre.com, brgl@bgdev.pl,
        gregkh@linuxfoundation.org, srinivas.kandagatla@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 05 Aug 2019 07:25:49 +0200
Message-ID: <15649827492583@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 25e5ef302c24a6fead369c0cfe88c073d7b97ca8 Mon Sep 17 00:00:00 2001
From: Jean Delvare <jdelvare@suse.de>
Date: Sun, 28 Jul 2019 18:41:38 +0200
Subject: [PATCH] eeprom: at24: make spd world-readable again

The integration of the at24 driver into the nvmem framework broke the
world-readability of spd EEPROMs. Fix it.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: stable@vger.kernel.org
Fixes: 57d155506dd5 ("eeprom: at24: extend driver to plug into the NVMEM framework")
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Bartosz Golaszewski <brgl@bgdev.pl>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>

diff --git a/drivers/misc/eeprom/at24.c b/drivers/misc/eeprom/at24.c
index 35bf2477693d..518945b2f737 100644
--- a/drivers/misc/eeprom/at24.c
+++ b/drivers/misc/eeprom/at24.c
@@ -685,7 +685,7 @@ static int at24_probe(struct i2c_client *client)
 	nvmem_config.name = dev_name(dev);
 	nvmem_config.dev = dev;
 	nvmem_config.read_only = !writable;
-	nvmem_config.root_only = true;
+	nvmem_config.root_only = !(flags & AT24_FLAG_IRUGO);
 	nvmem_config.owner = THIS_MODULE;
 	nvmem_config.compat = true;
 	nvmem_config.base_dev = dev;

