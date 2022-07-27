Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72C05582AD1
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234914AbiG0QYg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:24:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235390AbiG0QX6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:23:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18C184D155;
        Wed, 27 Jul 2022 09:23:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 37607619D0;
        Wed, 27 Jul 2022 16:22:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EF3EC43470;
        Wed, 27 Jul 2022 16:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658938977;
        bh=3iCMFHDjs1WQc6tiSgGz2iqgwppC7LL8WG2EUZz6tfg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GU86tkKkFz4n4347T9qqkEyInBhJnW7Ubb4SlxuWK1H9gaXXHgb5k6wu53xw87wU+
         PTL6us4EtEpkRDB2rX8h5Clg3KWhRceo4TSNX6mvg+3wlCIokn2IYBMdPN6jtN9X/c
         nf/EqTOp5B3NNsxoJUEd3NmH6lSJtBmIirLLJaGc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.9 20/26] ALSA: memalloc: Align buffer allocations in page size
Date:   Wed, 27 Jul 2022 18:10:49 +0200
Message-Id: <20220727160959.929028820@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727160959.122591422@linuxfoundation.org>
References: <20220727160959.122591422@linuxfoundation.org>
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
@@ -177,6 +177,7 @@ int snd_dma_alloc_pages(int type, struct
 	if (WARN_ON(!dmab))
 		return -ENXIO;
 
+	size = PAGE_ALIGN(size);
 	dmab->dev.type = type;
 	dmab->dev.dev = device;
 	dmab->bytes = 0;


