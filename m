Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51D6D6E14D3
	for <lists+stable@lfdr.de>; Thu, 13 Apr 2023 21:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbjDMTG0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Apr 2023 15:06:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbjDMTGY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Apr 2023 15:06:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A00707D83
        for <stable@vger.kernel.org>; Thu, 13 Apr 2023 12:05:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681412743;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UCBVyFd5BBmA+6Xv/IIgNhhtsz0B8DYXHt8AQVnFyEY=;
        b=JYrUSWJHMmHgS4FJ68oJQdEpc5j58YzOXfQtGhGLFdS5QZa2wvUFXu0d1Xy0lp4tEhh+6z
        H93klzMUbmR+ds5/NFTtiJZ3LeLDhA2+vhuOJ1gDOnJtLLMXkR4IEp2sM3lnk7159hNaGt
        Hkn6uiUIbrIR+qTRTJdizia7vbA3J0c=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-382-dlckrzlDPySYfOnH9Z2FAQ-1; Thu, 13 Apr 2023 15:05:35 -0400
X-MC-Unique: dlckrzlDPySYfOnH9Z2FAQ-1
Received: by mail-ed1-f72.google.com with SMTP id a5-20020a509e85000000b0050504899d78so3256331edf.16
        for <stable@vger.kernel.org>; Thu, 13 Apr 2023 12:05:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681412734; x=1684004734;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UCBVyFd5BBmA+6Xv/IIgNhhtsz0B8DYXHt8AQVnFyEY=;
        b=id9oZVRN6zMS3FGRBK4ub/erAgUScS7z1Q0D/mwjZCYDCTwCl3VG3uSroA/JwZfnM6
         bPYdj9sMPu796DN39qZf0aFvqxGT9bDvnM4pWiMb8eSB891YDL0+/34kM44tNGCMm3JB
         sQbT0H3x27E71P6L5Yn85uLhbRBJ4E0QXau2rQ0r7TtOdt5h4l7ylIYsY5wa2moRlVu+
         2AkTxyMkaIx2IN+R2x1GelDyaybeCe2yyyhWGKC0PrjOZJInPHbAQMN/ycLqrtxhxk/o
         N+XedtTrfuWmJhwklpVtB+mYuqJZuouKhevgbwdVEE61vNSj8vMRdFqkW90c6pP5JpU2
         mYBQ==
X-Gm-Message-State: AAQBX9cY0blGSd7FgCauGwYwHYadHSrct4a2yB8ridd+9sLBmwsPGsAI
        P+wczuuud9DplYIfahTbmKJWKhl4lO8dq63rpyRQQDRz5oY+xmYTzm8kH8r3QzGRIq4C+P2vBNy
        o3X7tp2Dpa5NHjS0x
X-Received: by 2002:a17:907:7783:b0:92b:f118:ef32 with SMTP id ky3-20020a170907778300b0092bf118ef32mr3344069ejc.48.1681412734063;
        Thu, 13 Apr 2023 12:05:34 -0700 (PDT)
X-Google-Smtp-Source: AKy350b0NoeyqPTndxzzpsGhufBoItrSucdDKVSwz86SIeJfM9Bqvf0Y1jAxX92P52cAl7P9mNqd0A==
X-Received: by 2002:a17:907:7783:b0:92b:f118:ef32 with SMTP id ky3-20020a170907778300b0092bf118ef32mr3344059ejc.48.1681412733732;
        Thu, 13 Apr 2023 12:05:33 -0700 (PDT)
Received: from [192.168.42.222] (194-45-78-10.static.kviknet.net. [194.45.78.10])
        by smtp.gmail.com with ESMTPSA id gz1-20020a170907a04100b0094a6ba1f5ccsm1368474ejc.22.2023.04.13.12.05.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Apr 2023 12:05:33 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <e7d81a89-da60-1da6-7966-7739ad545834@redhat.com>
Date:   Thu, 13 Apr 2023 21:05:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Cc:     brouer@redhat.com, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, xdp-hints@xdp-project.net,
        stable@vger.kernel.org
Subject: Re: [PATCH net 1/1] igc: read before write to SRRCTL register
Content-Language: en-US
To:     Song Yoong Siang <yoong.siang.song@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Vedang Patel <vedang.patel@intel.com>,
        Jithu Joseph <jithu.joseph@intel.com>,
        Andre Guedes <andre.guedes@intel.com>,
        Stanislav Fomichev <sdf@google.com>
References: <20230413151222.1864307-1-yoong.siang.song@intel.com>
In-Reply-To: <20230413151222.1864307-1-yoong.siang.song@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 13/04/2023 17.12, Song Yoong Siang wrote:
> igc_configure_rx_ring() function will be called as part of XDP program
> setup. If Rx hardware timestamp is enabled prio to XDP program setup,
> this timestamp enablement will be overwritten when buffer size is
> written into SRRCTL register.
> 
> Thus, this commit read the register value before write to SRRCTL
> register. This commit is tested by using xdp_hw_metadata bpf selftest
> tool. The tool enables Rx hardware timestamp and then attach XDP program
> to igc driver. It will display hardware timestamp of UDP packet with
> port number 9092. Below are detail of test steps and results.
[...]
> diff --git a/drivers/net/ethernet/intel/igc/igc_base.h b/drivers/net/ethernet/intel/igc/igc_base.h
> index 7a992befca24..b95007d51d13 100644
> --- a/drivers/net/ethernet/intel/igc/igc_base.h
> +++ b/drivers/net/ethernet/intel/igc/igc_base.h
> @@ -87,8 +87,11 @@ union igc_adv_rx_desc {
>   #define IGC_RXDCTL_SWFLUSH		0x04000000 /* Receive Software Flush */
>   
>   /* SRRCTL bit definitions */
> -#define IGC_SRRCTL_BSIZEPKT_SHIFT		10 /* Shift _right_ */
> -#define IGC_SRRCTL_BSIZEHDRSIZE_SHIFT		2  /* Shift _left_ */
> +#define IGC_SRRCTL_BSIZEPKT_MASK	GENMASK(6, 0)
> +#define IGC_SRRCTL_BSIZEPKT_SHIFT	10 /* Shift _right_ */
> +#define IGC_SRRCTL_BSIZEHDRSIZE_MASK	GENMASK(13, 8)
> +#define IGC_SRRCTL_BSIZEHDRSIZE_SHIFT	2  /* Shift _left_ */
> +#define IGC_SRRCTL_DESCTYPE_MASK	GENMASK(27, 25)
>   #define IGC_SRRCTL_DESCTYPE_ADV_ONEBUF	0x02000000
>   
>   #endif /* _IGC_BASE_H */
> diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
> index 25fc6c65209b..de7b21c2ccd6 100644
> --- a/drivers/net/ethernet/intel/igc/igc_main.c
> +++ b/drivers/net/ethernet/intel/igc/igc_main.c
> @@ -641,7 +641,10 @@ static void igc_configure_rx_ring(struct igc_adapter *adapter,
>   	else
>   		buf_size = IGC_RXBUFFER_2048;
>   
> -	srrctl = IGC_RX_HDR_LEN << IGC_SRRCTL_BSIZEHDRSIZE_SHIFT;
> +	srrctl = rd32(IGC_SRRCTL(reg_idx));
> +	srrctl &= ~(IGC_SRRCTL_BSIZEPKT_MASK | IGC_SRRCTL_BSIZEHDRSIZE_MASK |
> +		  IGC_SRRCTL_DESCTYPE_MASK);
                   ^^
Please fix indention, moving IGC_SRRCTL_DESCTYPE_MASK such that it
aligns with IGC_SRRCTL_BSIZEPKT_MASK.  This make is easier for the eye
to spot that it is part of the negation (~).

> +	srrctl |= IGC_RX_HDR_LEN << IGC_SRRCTL_BSIZEHDRSIZE_SHIFT;
>   	srrctl |= buf_size >> IGC_SRRCTL_BSIZEPKT_SHIFT;
>   	srrctl |= IGC_SRRCTL_DESCTYPE_ADV_ONEBUF;
>   

