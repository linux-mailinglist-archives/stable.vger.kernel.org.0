Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E435595E6B
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 16:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234015AbiHPOgC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 10:36:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233407AbiHPOgB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 10:36:01 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4565B07CC
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 07:35:59 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id u3so15175731lfk.8
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 07:35:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=h3EmMfFSSsyNkzew1dfFY9Ofcl9m+lhYwUeJAHWJUP0=;
        b=UDT7qAYDtWoHIdbzdwuiR4MqI4jCJNa9i/Rm6NJ3OEGLsbHmTfI3yeI3yCPOsRZ+vI
         UvqeCv9dKy+TvX+q+3xheeWjFk712BkbH6OigFuJT89EzYgZSfqyYY3+vgdNmrrmz8ev
         IsyRPJz8vMe+16vlHrNQqo19fMiSMmkmGTYf6WstAAQMgnkdrUcIJ51lcZ0+gpAknNbu
         BvhZl0E4QAgWQ7ZIUZJ1Gvmsc+ZzmZfaH4CqeiigCub7KYxXMtjNJgreTDInt6PgFBY5
         qstvevcgxujPhMV+n1JQW6AwNRhisKa1mZ/ujUqPHWwty4j6XESMer6sTzOPrtYz+4Kq
         c5WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=h3EmMfFSSsyNkzew1dfFY9Ofcl9m+lhYwUeJAHWJUP0=;
        b=zrI5pNf6edSnVkC4Blvf/iGhTzXOx+ey9NMca1hST9NKnedGQDRRUpAOgL+E93GFvF
         ruNnd0Ak5l4qMwod2Rm3gHSK3v6OpS9AJP1hIbbFdN2mPMtUNcfMGasHq0gF3y5Ya/25
         I7+RkeWqlL6QoRTBXad1YzbeRDm/gnZ3+BEHPOP0yN9Fv1SqoL/qUi6uF4a3W6Rtbzfz
         BEg0kjcz2Q3NlQxLk8TV4/mdax0Z07zXp8rresij5C3Af8hOeX3qK6VhJ6owpZaulPgI
         sZha81qxYfD/vqwpDxuFxqYgDnDsuJXZ4NYXqgrmRYedgUCXGfL7Lh6f0GdUqe6oE5GA
         LXfQ==
X-Gm-Message-State: ACgBeo11jOpLVt3UngKxmBW4W3+E5yt1COSlsvKxBb34jq8UVOc7G00m
        gSt2Agn/rFSRiC8/59XDKfLKs0UgXAYi
X-Google-Smtp-Source: AA6agR7tb6OxGufEnbEMzboV0hoXMv9QcUdWqiakVfkAGZ1QuiUFk/OncEkli20lixhm00vxzAf98w==
X-Received: by 2002:ac2:4562:0:b0:48b:2a91:e59 with SMTP id k2-20020ac24562000000b0048b2a910e59mr7063354lfm.91.1660660558178;
        Tue, 16 Aug 2022 07:35:58 -0700 (PDT)
Received: from Mem (2a01cb0890e296006905f2f810da8415.ipv6.abo.wanadoo.fr. [2a01:cb08:90e2:9600:6905:f2f8:10da:8415])
        by smtp.gmail.com with ESMTPSA id q16-20020a2eb4b0000000b0025d75995a07sm1824061ljm.24.2022.08.16.07.35.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 07:35:57 -0700 (PDT)
Date:   Tue, 16 Aug 2022 16:35:54 +0200
From:   Paul Chaignon <paul@isovalent.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.19 0537/1157] bpf: Set flow flag to allow any source IP
 in bpf_tunnel_key
Message-ID: <20220816143554.GA67569@Mem>
References: <20220815180439.416659447@linuxfoundation.org>
 <20220815180501.149595269@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220815180501.149595269@linuxfoundation.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 15, 2022 at 07:58:13PM +0200, Greg Kroah-Hartman wrote:
> From: Paul Chaignon <paul@isovalent.com>
> 
> [ Upstream commit b8fff748521c7178b9a7d32b5a34a81cec8396f3 ]
> 
> Commit 26101f5ab6bd ("bpf: Add source ip in "struct bpf_tunnel_key"")
> added support for getting and setting the outer source IP of encapsulated
> packets via the bpf_skb_{get,set}_tunnel_key BPF helper. This change
> allows BPF programs to set any IP address as the source, including for
> example the IP address of a container running on the same host.
> 
> In that last case, however, the encapsulated packets are dropped when
> looking up the route because the source IP address isn't assigned to any
> interface on the host. To avoid this, we need to set the
> FLOWI_FLAG_ANYSRC flag.

This fix will also require upstream commits 861396ac0b47 ("geneve: Use
ip_tunnel_key flow flags in route lookups") and 7e2fb8bc7ef6 ("vxlan:
Use ip_tunnel_key flow flags in route lookups") to have the intended
effect. In short, these two commits "consume" the new field introduced
in 451ef36bd229 ("ip_tunnels: Add new flow flags field to
ip_tunnel_key") and populated in the present commit.

> 
> Fixes: 26101f5ab6bd ("bpf: Add source ip in "struct bpf_tunnel_key"")
> Signed-off-by: Paul Chaignon <paul@isovalent.com>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
> Acked-by: Martin KaFai Lau <kafai@fb.com>
> Link: https://lore.kernel.org/bpf/76873d384e21288abe5767551a0799ac93ec07fb.1658759380.git.paul@isovalent.com
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  net/core/filter.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 7950f7520765..5978984b752f 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -4653,6 +4653,7 @@ BPF_CALL_4(bpf_skb_set_tunnel_key, struct sk_buff *, skb,
>  	} else {
>  		info->key.u.ipv4.dst = cpu_to_be32(from->remote_ipv4);
>  		info->key.u.ipv4.src = cpu_to_be32(from->local_ipv4);
> +		info->key.flow_flags = FLOWI_FLAG_ANYSRC;
>  	}
>  
>  	return 0;
> -- 
> 2.35.1
> 
> 
> 
