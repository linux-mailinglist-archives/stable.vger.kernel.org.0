Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E6C52B5640
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 02:27:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729485AbgKQBZN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Nov 2020 20:25:13 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7690 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726387AbgKQBZN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Nov 2020 20:25:13 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CZpC86y4JzkYxZ;
        Tue, 17 Nov 2020 09:24:52 +0800 (CST)
Received: from [10.174.176.185] (10.174.176.185) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.487.0; Tue, 17 Nov 2020 09:25:09 +0800
Subject: Re: [PATCH] ubifs: wbuf: Don't leak kernel memory to flash
To:     Richard Weinberger <richard@nod.at>,
        <linux-mtd@lists.infradead.org>
CC:     <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
References: <20201116210530.26230-1-richard@nod.at>
From:   Zhihao Cheng <chengzhihao1@huawei.com>
Message-ID: <bfea268f-b5c2-5467-7b17-5eef7b0269ce@huawei.com>
Date:   Tue, 17 Nov 2020 09:25:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20201116210530.26230-1-richard@nod.at>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.176.185]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

ÔÚ 2020/11/17 5:05, Richard Weinberger Ð´µÀ:
> Write buffers use a kmalloc()'ed buffer, they can leak
> up to seven bytes of kernel memory to flash if writes are not
> aligned.
> So use ubifs_pad() to fill these gaps with padding bytes.
> This was never a problem while scanning because the scanner logic
> manually aligns node lengths and skips over these gaps.
> 
> Cc: <stable@vger.kernel.org>
> Fixes: 1e51764a3c2ac05a2 ("UBIFS: add new flash file system")
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>   fs/ubifs/io.c | 13 +++++++++++--
>   1 file changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ubifs/io.c b/fs/ubifs/io.c
> index 7e4bfaf2871f..eae9cf5a57b0 100644
> --- a/fs/ubifs/io.c
> +++ b/fs/ubifs/io.c
> @@ -319,7 +319,7 @@ void ubifs_pad(const struct ubifs_info *c, void *buf, int pad)
>   {
>   	uint32_t crc;
>   
> -	ubifs_assert(c, pad >= 0 && !(pad & 7));
> +	ubifs_assert(c, pad >= 0);
>   
>   	if (pad >= UBIFS_PAD_NODE_SZ) {
>   		struct ubifs_ch *ch = buf;
> @@ -764,6 +764,10 @@ int ubifs_wbuf_write_nolock(struct ubifs_wbuf *wbuf, void *buf, int len)
>   		 * write-buffer.
>   		 */
>   		memcpy(wbuf->buf + wbuf->used, buf, len);
> +		if (aligned_len > len) {
> +			ubifs_assert(c, aligned_len - len < 8);
> +			ubifs_pad(c, wbuf->buf + wbuf->used + len, aligned_len - len);
> +		}
>   
>   		if (aligned_len == wbuf->avail) {
>   			dbg_io("flush jhead %s wbuf to LEB %d:%d",
> @@ -856,13 +860,18 @@ int ubifs_wbuf_write_nolock(struct ubifs_wbuf *wbuf, void *buf, int len)
>   	}
>   
>   	spin_lock(&wbuf->lock);
> -	if (aligned_len)
> +	if (aligned_len) {
>   		/*
>   		 * And now we have what's left and what does not take whole
>   		 * max. write unit, so write it to the write-buffer and we are
>   		 * done.
>   		 */
>   		memcpy(wbuf->buf, buf + written, len);
> +		if (aligned_len > len) {
> +			ubifs_assert(c, aligned_len - len < 8);
> +			ubifs_pad(c, wbuf->buf + len, aligned_len - len);
> +		}
> +	}
>   
>   	if (c->leb_size - wbuf->offs >= c->max_write_size)
>   		wbuf->size = c->max_write_size;
> 

Reviewed-by: Zhihao Cheng <chengzhihao1@huawei.com>
