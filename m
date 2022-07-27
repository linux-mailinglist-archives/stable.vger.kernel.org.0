Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7055582D46
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240975AbiG0QzU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241211AbiG0Qyg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:54:36 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EFE3564FA;
        Wed, 27 Jul 2022 09:35:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6A2ECCE22F9;
        Wed, 27 Jul 2022 16:35:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81E38C433C1;
        Wed, 27 Jul 2022 16:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939740;
        bh=ah6HZXPTHtNEbP7zu+5lTh/rq8pif47I4x0TvqU/K+s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ggnv2JVPWZLshnmEKObNo/lkhXexRhaVu8B0nYBf8jWPNw4W5qJr+V0fw9OH57MTc
         RFejexyquHAGRlm/RMSwTBEL37RUMW5imU4fd8tYvGw845JsZfAmUSNiTw8WmB0Vky
         YoJJZ1mhCjl1+2/iCUTKqoRYpnuX31g7BOtwC8Vo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 086/105] ALSA: memalloc: Align buffer allocations in page size
Date:   Wed, 27 Jul 2022 18:11:12 +0200
Message-Id: <20220727161015.555280649@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161012.056867467@linuxfoundation.org>
References: <20220727161012.056867467@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 5c1733e33c888a3cb7f576564d8ad543d5ad4a9e upstream.

Currently the standard memory allocator (snd_dma_malloc_pages*())
passes the byte size to allocate as is.  Most of the backends
allocates real pages, hence the actual allocations are aligned in page
size.  However, the genalloc doesn't seem assuring the size alignment,
hence it may result in the access outside the buffer when the whole
memory pages are exposed via mmap.

For avoiding such inconsistencies, this patch makes the allocation
size always to be aligned in page size.

Note that, after this change, snd_dma_buffer.bytes field contains the
aligned size, not the originally requested size.  This value is also
used for releasing the pages in return.

Reviewed-by: Lars-Peter Clausen <lars@metafoo.de>
Link: https://lore.kernel.org/r/20201218145625.2045-2-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/memalloc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/core/memalloc.c
+++ b/sound/core/memalloc.c
@@ -133,6 +133,7 @@ int snd_dma_alloc_pages(int type, struct
 	if (WARN_ON(!dmab))
 		return -ENXIO;
 
+	size = PAGE_ALIGN(size);
 	dmab->dev.type = type;
 	dmab->dev.dev = device;
 	dmab->bytes = 0;


