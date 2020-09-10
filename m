Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44831264FF9
	for <lists+stable@lfdr.de>; Thu, 10 Sep 2020 21:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726997AbgIJTyT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Sep 2020 15:54:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727116AbgIJTwg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Sep 2020 15:52:36 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EBACC061756;
        Thu, 10 Sep 2020 12:43:23 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id z9so1632644wmk.1;
        Thu, 10 Sep 2020 12:43:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CwGn8n9DjuYuvwODgQD4bX4lUI5/xXZdPT97oPczTMs=;
        b=KJZM7y9hdzVyWNf7f1qoB4Wktk621YrUrhpUDOvcukvT63EF8R84wlJhvi/P5GxTF2
         DgVnMn1cewgEZQrEK2Zb53S8pO9k647dGn76eTm/AtFHqrTR7/+lOwsRnWSzqhDOnG6u
         wUTJ6aPYl+wy4HH7oPfEqHSW+hb9/FrcgFBs46tcM26e4y/zJ97lex0sFhYvT1/gb9c1
         yeKQNR1y16R9kp0WhLClrK/AQf1aZC7mYinv8KUN2L1XnUNi9/o0TWcrm8u6KI7McujW
         03F2bXayfNo65nRhrpbSK/YkmQQ1ilzYwkOBvhR3enSXoQUR88NlUICxoCj1sM90fhoc
         tU9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=CwGn8n9DjuYuvwODgQD4bX4lUI5/xXZdPT97oPczTMs=;
        b=D/k3DpOYIlyzBqDNmxQD5uigc8OXQrXCjiawVbTVa2NYRjL05akYJ4SQU/G2xajCMS
         muIV24/+V9mnYgENTi55NYx+Q03jjJsGJqYskX6slzWyk3RZ9XuuQZCCBzkcZmXRoN05
         TKrh9hyB3LHNzSsB5Ti/4lOzeFh+oJf7oF5ynHETp/fcg8xnplI4fWjwr9aP7jhj5ekN
         U7xGEq9BglCruhiSK38p1Rdn2JwQhrvYK8ly6h1MQV3fFbE8YYlhZU7zSAEyLdcN1xG5
         NSIVtID7pfd72qHLsT2E6aJw8xQikFIyJmsA+SfPrG2/kmJpSPwDXDI3odcxcuxPQoLN
         G7Sg==
X-Gm-Message-State: AOAM531+DEb6TcsIuOs/IXeiNwcUpw9lE2d2k6EfVXEgbRP1U6enManX
        tdojebQMBcQe+0EU2WPaHDbg0RqvPXFXDQ==
X-Google-Smtp-Source: ABdhPJy9Wbjk4v9KRoN+PO6CaMB3PwTmTGG7o5JJ6kOlB4GKYR8FUebB9/YpCVx7HTvK1/f3NRJifA==
X-Received: by 2002:a05:600c:414e:: with SMTP id h14mr1617383wmm.2.1599767001805;
        Thu, 10 Sep 2020 12:43:21 -0700 (PDT)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id q186sm5099567wma.45.2020.09.10.12.43.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2020 12:43:20 -0700 (PDT)
Date:   Thu, 10 Sep 2020 21:43:19 +0200
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>, Daniel.Craig@csiro.au,
        Nicolas Courtel <courtel@cena.fr>
Subject: Re: [PATCH 4.19 142/206] gfs2: fix use-after-free on transaction ail
 lists
Message-ID: <20200910194319.GA131386@eldamar.local>
References: <20200623195316.864547658@linuxfoundation.org>
 <20200623195323.968867013@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200623195323.968867013@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Tue, Jun 23, 2020 at 09:57:50PM +0200, Greg Kroah-Hartman wrote:
> From: Bob Peterson <rpeterso@redhat.com>
> 
> [ Upstream commit 83d060ca8d90fa1e3feac227f995c013100862d3 ]
> 
> Before this patch, transactions could be merged into the system
> transaction by function gfs2_merge_trans(), but the transaction ail
> lists were never merged. Because the ail flushing mechanism can run
> separately, bd elements can be attached to the transaction's buffer
> list during the transaction (trans_add_meta, etc) but quickly moved
> to its ail lists. Later, in function gfs2_trans_end, the transaction
> can be freed (by gfs2_trans_end) while it still has bd elements
> queued to its ail lists, which can cause it to either lose track of
> the bd elements altogether (memory leak) or worse, reference the bd
> elements after the parent transaction has been freed.
> 
> Although I've not seen any serious consequences, the problem becomes
> apparent with the previous patch's addition of:
> 
> 	gfs2_assert_warn(sdp, list_empty(&tr->tr_ail1_list));
> 
> to function gfs2_trans_free().
> 
> This patch adds logic into gfs2_merge_trans() to move the merged
> transaction's ail lists to the sdp transaction. This prevents the
> use-after-free. To do this properly, we need to hold the ail lock,
> so we pass sdp into the function instead of the transaction itself.
> 
> Signed-off-by: Bob Peterson <rpeterso@redhat.com>
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  fs/gfs2/log.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
> index d3f0612e33471..06752db213d21 100644
> --- a/fs/gfs2/log.c
> +++ b/fs/gfs2/log.c
> @@ -877,8 +877,10 @@ void gfs2_log_flush(struct gfs2_sbd *sdp, struct gfs2_glock *gl, u32 flags)
>   * @new: New transaction to be merged
>   */
>  
> -static void gfs2_merge_trans(struct gfs2_trans *old, struct gfs2_trans *new)
> +static void gfs2_merge_trans(struct gfs2_sbd *sdp, struct gfs2_trans *new)
>  {
> +	struct gfs2_trans *old = sdp->sd_log_tr;
> +
>  	WARN_ON_ONCE(!test_bit(TR_ATTACHED, &old->tr_flags));
>  
>  	old->tr_num_buf_new	+= new->tr_num_buf_new;
> @@ -890,6 +892,11 @@ static void gfs2_merge_trans(struct gfs2_trans *old, struct gfs2_trans *new)
>  
>  	list_splice_tail_init(&new->tr_databuf, &old->tr_databuf);
>  	list_splice_tail_init(&new->tr_buf, &old->tr_buf);
> +
> +	spin_lock(&sdp->sd_ail_lock);
> +	list_splice_tail_init(&new->tr_ail1_list, &old->tr_ail1_list);
> +	list_splice_tail_init(&new->tr_ail2_list, &old->tr_ail2_list);
> +	spin_unlock(&sdp->sd_ail_lock);
>  }
>  
>  static void log_refund(struct gfs2_sbd *sdp, struct gfs2_trans *tr)
> @@ -901,7 +908,7 @@ static void log_refund(struct gfs2_sbd *sdp, struct gfs2_trans *tr)
>  	gfs2_log_lock(sdp);
>  
>  	if (sdp->sd_log_tr) {
> -		gfs2_merge_trans(sdp->sd_log_tr, tr);
> +		gfs2_merge_trans(sdp, tr);
>  	} else if (tr->tr_num_buf_new || tr->tr_num_databuf_new) {
>  		gfs2_assert_withdraw(sdp, test_bit(TR_ALLOCED, &tr->tr_flags));
>  		sdp->sd_log_tr = tr;
> -- 
> 2.25.1

In Debian two user confirmed issues on writing on a GFS2 partition
with this commit applied. The initial Debian report is at
https://bugs.debian.org/968567 and Daniel Craig reported it into
Bugzilla at https://bugzilla.kernel.org/show_bug.cgi?id=209217 .

Writing to a gfs2 filesystem fails and results in a soft lookup of the
machine for kernels with that commit applied. I cannot reporduce the
issue myself due not having a respective setup available, but Daniel
described a minimal serieos of steps to reproduce the issue.

This might affect as well other stable series where this commit was
applied, as there was a similar report for someone running 5.4.58 in
https://www.redhat.com/archives/linux-cluster/2020-August/msg00000.html
.

Regards,
Salvatore
