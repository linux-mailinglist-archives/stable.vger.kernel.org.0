Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D8D11A0B93
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 12:27:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728810AbgDGK0g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 06:26:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:38748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728827AbgDGK0f (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Apr 2020 06:26:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F245F2074B;
        Tue,  7 Apr 2020 10:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586255195;
        bh=d+xqoosQWAFmA/UHu9JFAwrIxg7k77vrafrDNJe0OWI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kPP8RbE5fhFpO3lKfdQDuynxc2z9GBiHmh2imtqYbbQDXJ2RLKogVprcLcmYYSLOK
         ESmw0rBEeOIWwLlkjsep5fZnOn/cwCVgIjSAwDKkuuSTormhXjNZBr5RcUTN8+59ak
         kJErf1b1gVAcMubXnX4QyiOOjiDjcE/YAGkOmd24=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Khouloud Touil <ktouil@baylibre.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 5.6 21/29] nvmem: release the write-protect pin
Date:   Tue,  7 Apr 2020 12:22:18 +0200
Message-Id: <20200407101454.643321516@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200407101452.046058399@linuxfoundation.org>
References: <20200407101452.046058399@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Khouloud Touil <ktouil@baylibre.com>

commit a9c3766cb19cdadf2776aba41b64470002645894 upstream.

Put the write-protect GPIO descriptor in nvmem_release() so that it can
be automatically released when the associated device's reference count
drops to 0.

Fixes: 2a127da461a9 ("nvmem: add support for the write-protect pin")
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Khouloud Touil <ktouil@baylibre.com>
Cc: stable <stable@vger.kernel.org>
[Bartosz: tweak the commit message]
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20200310132257.23358-8-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/nvmem/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -72,6 +72,7 @@ static void nvmem_release(struct device
 	struct nvmem_device *nvmem = to_nvmem_device(dev);
 
 	ida_simple_remove(&nvmem_ida, nvmem->id);
+	gpiod_put(nvmem->wp_gpio);
 	kfree(nvmem);
 }
 


