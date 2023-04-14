Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E0096E1FC6
	for <lists+stable@lfdr.de>; Fri, 14 Apr 2023 11:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbjDNJvP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Apr 2023 05:51:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbjDNJvN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Apr 2023 05:51:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 976D46EA1
        for <stable@vger.kernel.org>; Fri, 14 Apr 2023 02:50:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681465827;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kD03/VZMnuU+AkWoElhnvOWf3hPE4VUEKVtpsqSBK8c=;
        b=fOb2bO7E0zKhGXATrCotwEis+C/iA9HFg7QMqSystt+RlteCsDNl9qXPzAexh2ltpiOyfp
        06+NFx0NwoYlqArdqRx8mEL0g5b505K1lu6DXKv6hcabDD1NoMSWNOf4wgbKMb+EglKU5i
        KL/SUG/CXDTsgoxwvUzIxfxPCQ7te9k=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-554-XqrJfXkkPW6V6tJjxr0UZg-1; Fri, 14 Apr 2023 05:50:24 -0400
X-MC-Unique: XqrJfXkkPW6V6tJjxr0UZg-1
Received: by mail-ed1-f70.google.com with SMTP id e20-20020a50d4d4000000b00505059e6162so4096515edj.11
        for <stable@vger.kernel.org>; Fri, 14 Apr 2023 02:50:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681465823; x=1684057823;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kD03/VZMnuU+AkWoElhnvOWf3hPE4VUEKVtpsqSBK8c=;
        b=Dc7573aF2e7BfzXVmj08Qs8fVlfUujhvCXuXf9H6LwfBRZyzFKiTjo0TWqYhtTH/ot
         VwxpNIcIhKPdXYN107pX/3hReUuW11u89/uWA6tjUB26DpQVgPSRK96CalJ6S/G4mACq
         Ju14LhGTDSXu9gMb59jwkjzCgRyTAHVj1L7iwedW9kzOKoZj3/zka1vs8whkIgh+fL/C
         S1nE6XVjUGbOpLzeLo9K3S+KXCYJ7X/xDyjKkMZQP09zy9I9SP7YZxkd/mXilzWlECNu
         EXt2mm4ZREsTDrL4B7Rwm57JSpBhaDc5CH2L07wT7qBoE2MzKgl8qEKKupdQlteWoLqT
         W7JA==
X-Gm-Message-State: AAQBX9dWWVjzlV5muAiibRgO+lXuXNDJNSiCmzWifR/uBIc1KE/F1Ouq
        EMMTSLC3jteqYeWgoBQUFB/tus4G9cojYHiTD7ALHft+q5rq1fUwEMBr21hNFlKiPRqb51HIa2F
        03I7po4VkFVucn82L
X-Received: by 2002:a17:907:9808:b0:94e:7ddf:3ea4 with SMTP id ji8-20020a170907980800b0094e7ddf3ea4mr4486407ejc.24.1681465823380;
        Fri, 14 Apr 2023 02:50:23 -0700 (PDT)
X-Google-Smtp-Source: AKy350a6+Z5LefT4FRvBDLayHSHXZA3qQHN2R00EVjv3yDfVy5sfO/pP+qKrWWJLMzDXhuVJ7vw4Pw==
X-Received: by 2002:a17:907:9808:b0:94e:7ddf:3ea4 with SMTP id ji8-20020a170907980800b0094e7ddf3ea4mr4486375ejc.24.1681465823000;
        Fri, 14 Apr 2023 02:50:23 -0700 (PDT)
Received: from [192.168.42.222] (194-45-78-10.static.kviknet.net. [194.45.78.10])
        by smtp.gmail.com with ESMTPSA id y20-20020a170906559400b0094a7e4dfed8sm2189942ejp.47.2023.04.14.02.50.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Apr 2023 02:50:22 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <8214fb10-8caa-4418-8435-85b6ac27b69e@redhat.com>
Date:   Fri, 14 Apr 2023 11:50:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Cc:     brouer@redhat.com, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, xdp-hints@xdp-project.net,
        stable@vger.kernel.org
Subject: Re: [PATCH net v2 1/1] igc: read before write to SRRCTL register
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
        Stanislav Fomichev <sdf@google.com>,
        Jacob Keller <jacob.e.keller@intel.com>
References: <20230414020915.1869456-1-yoong.siang.song@intel.com>
In-Reply-To: <20230414020915.1869456-1-yoong.siang.song@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 14/04/2023 04.09, Song Yoong Siang wrote:
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
> 
> Command on DUT:
>    sudo ./xdp_hw_metadata <interface name>
> 
> Command on Link Partner:
>    echo -n skb | nc -u -q1 <destination IPv4 addr> 9092
> 
> Result before this patch:
>    skb hwtstamp is not found!
> 
> Result after this patch:
>    found skb hwtstamp = 1677800973.642836757
> 
> Optionally, read PHC to confirm the values obtained are almost the same:
> Command:
>    sudo ./testptp -d /dev/ptp0 -g
> Result:
>    clock time: 1677800973.913598978 or Fri Mar  3 07:49:33 2023
> 
> Fixes: fc9df2a0b520 ("igc: Enable RX via AF_XDP zero-copy")
> Cc: <stable@vger.kernel.org> # 5.14+
> Signed-off-by: Song Yoong Siang <yoong.siang.song@intel.com>
> Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
> ---

Reviewed-by: Jesper Dangaard Brouer <brouer@redhat.com>

> v2 changelog:
>   - Fix indention
> ---
>   drivers/net/ethernet/intel/igc/igc_base.h | 7 +++++--
>   drivers/net/ethernet/intel/igc/igc_main.c | 5 ++++-
>   2 files changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/igc/igc_base.h b/drivers/net/ethernet/intel/igc/igc_base.h
> index 7a992befca24..b95007d51d13 100644
> --- a/drivers/net/ethernet/intel/igc/igc_base.h
> +++ b/drivers/net/ethernet/intel/igc/igc_base.h
> @@ -87,8 +87,11 @@ union igc_adv_rx_desc {
>   #define IGC_RXDCTL_SWFLUSH		0x04000000 /* Receive Software Flush */
>   
>   /* SRRCTL bit definitions */

I have checked Foxville manual for SRRCTL (Split and Replication Receive
Control) register and below GENMASKs looks correct.

> -#define IGC_SRRCTL_BSIZEPKT_SHIFT		10 /* Shift _right_ */
> -#define IGC_SRRCTL_BSIZEHDRSIZE_SHIFT		2  /* Shift _left_ */
> +#define IGC_SRRCTL_BSIZEPKT_MASK	GENMASK(6, 0)
> +#define IGC_SRRCTL_BSIZEPKT_SHIFT	10 /* Shift _right_ */

Shift due to 1 KB resolution of BSIZEPKT (manual field BSIZEPACKET)

> +#define IGC_SRRCTL_BSIZEHDRSIZE_MASK	GENMASK(13, 8)
> +#define IGC_SRRCTL_BSIZEHDRSIZE_SHIFT	2  /* Shift _left_ */

This shift is suspicious, but as you inherited it I guess it works.
I did the math, and it happens to work, knowing (from manual) value is
in 64 bytes resolution.

> +#define IGC_SRRCTL_DESCTYPE_MASK	GENMASK(27, 25)
>   #define IGC_SRRCTL_DESCTYPE_ADV_ONEBUF	0x02000000

Given you have started using GENMASK(), then I would have updated 
IGC_SRRCTL_DESCTYPE_ADV_ONEBUF to be expressed like:

  #define IGC_SRRCTL_DESCTYPE_ADV_ONEBUF 
FIELD_PREP(IGC_SRRCTL_DESCTYPE_MASK, 0x1)

Making it easier to see code is selecting:
  001b = Advanced descriptor one buffer.

And not (as I first though):
  010b = Advanced descriptor header splitting.


>   #endif /* _IGC_BASE_H */
> diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
> index 25fc6c65209b..88fac08d8a14 100644
> --- a/drivers/net/ethernet/intel/igc/igc_main.c
> +++ b/drivers/net/ethernet/intel/igc/igc_main.c
> @@ -641,7 +641,10 @@ static void igc_configure_rx_ring(struct igc_adapter *adapter,
>   	else
>   		buf_size = IGC_RXBUFFER_2048;
>   
> -	srrctl = IGC_RX_HDR_LEN << IGC_SRRCTL_BSIZEHDRSIZE_SHIFT;
> +	srrctl = rd32(IGC_SRRCTL(reg_idx));
> +	srrctl &= ~(IGC_SRRCTL_BSIZEPKT_MASK | IGC_SRRCTL_BSIZEHDRSIZE_MASK |
> +		    IGC_SRRCTL_DESCTYPE_MASK);
> +	srrctl |= IGC_RX_HDR_LEN << IGC_SRRCTL_BSIZEHDRSIZE_SHIFT;
>   	srrctl |= buf_size >> IGC_SRRCTL_BSIZEPKT_SHIFT;
>   	srrctl |= IGC_SRRCTL_DESCTYPE_ADV_ONEBUF;
>   

