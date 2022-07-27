Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC5F0582C4B
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239868AbiG0Qou (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:44:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240212AbiG0QoM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:44:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14063BC06;
        Wed, 27 Jul 2022 09:30:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 97D18619FD;
        Wed, 27 Jul 2022 16:30:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6111C433D7;
        Wed, 27 Jul 2022 16:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939449;
        bh=0nPcMk7X2zRWW6IEONlkgBKjawbM0P/bEPivCLl7JwM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R0bLRql+90Ym3LF+bTVxOQ+Ly7ruLKS6FS4eI7Dmdcshn24QfQkHO5S/7PAmYm9yq
         XC1tgLQ8A/lbGawh26Djck7TG/djGGSY7pugBLnpQuvyRYHElZ3L9XlLTfLj2cGWj8
         3VJyMP0Fx0eA5ExnydGsvZa0P2Cfipi1F9ncEQJw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 73/87] ALSA: memalloc: Align buffer allocations in page size
Date:   Wed, 27 Jul 2022 18:11:06 +0200
Message-Id: <20220727161012.026313331@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161008.993711844@linuxfoundation.org>
References: <20220727161008.993711844@linuxfoundation.org>
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
@@ -124,6 +124,7 @@ int snd_dma_alloc_pages(int type, struct
 	if (WARN_ON(!device))
 		return -EINVAL;
 
+	size = PAGE_ALIGN(size);
 	dmab->dev.type = type;
 	dmab->dev.dev = device;
 	dmab->bytes = 0;


