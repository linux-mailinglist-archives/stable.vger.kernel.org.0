Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 657E83BA214
	for <lists+stable@lfdr.de>; Fri,  2 Jul 2021 16:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232677AbhGBOYL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Jul 2021 10:24:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29407 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232584AbhGBOYL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Jul 2021 10:24:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625235698;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Sma5BoejRfGVgsKn91ewTAqHSqX8AdF0MwNnrl1mCnM=;
        b=CJmsqI8/VKtojsT68wwV29TfAuu08iDhX9p8H5Y9C2cwchUTjMnhmKuRJwKKRyp99nksFV
        WOvjZPM6WzGYBiMSPNsw+IqNUtLLOoIqkT8G6vOzI3Silmzti4aF779KNmClRxSZNATC8o
        iY/Dod+llf+QJfI6qozc7EFFXLm8//w=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-518-Gus0tpLeNhWeGEH4OOVErg-1; Fri, 02 Jul 2021 10:21:37 -0400
X-MC-Unique: Gus0tpLeNhWeGEH4OOVErg-1
Received: by mail-wr1-f70.google.com with SMTP id v9-20020a5d4a490000b029011a86baa40cso3948000wrs.7
        for <stable@vger.kernel.org>; Fri, 02 Jul 2021 07:21:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=Sma5BoejRfGVgsKn91ewTAqHSqX8AdF0MwNnrl1mCnM=;
        b=FtebIWycma5z94WeukwhqsjV7lFln0gZGVC7L8BYgEe5wWNRi8ccmMpHDz/f3Ul1uR
         5bKxhyDCNiRAktEmcZu6XnY0t61pm0tEpXLMrzTl9dEShfUkpCh8bftzLyaRTfi1+FWZ
         he2DXiu7kybY2ANy5XjTc+CgXGchI9U8p9omak0zu1VBfa1wC16OYI0FFDaFR63t2JsI
         51kyjHMRUUtJkGajLIWE3e0lKrKcCOfRlfifkVuqha3QNOcwbnIh0gcnNGkvKX1oWpDH
         +XEwegscw4/RDqqYKpMvgSIp0md67JJY+NWuf0bxw2O/vo63mAD8nm72v17wW9mfg7Em
         CV9A==
X-Gm-Message-State: AOAM531fNH1r3Lu+XN8EutRKkBllRiJrdhRLFYOJ1Vs3kqsjVnI/tZZM
        ykOcyVwkQarsWxNx0/HkcBL31mb4T0x+uLiciYNxgME4j98LJHi/EOlBq0nKrwBHYkm9jkjyN4j
        dgQJsEHF5doSkRVe8
X-Received: by 2002:a7b:cc82:: with SMTP id p2mr32491wma.120.1625235696187;
        Fri, 02 Jul 2021 07:21:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwOAaMkNvMjsnDJPXbOLmSwL2zHyk6V/6ha+5UmQtuV1707Eexid74H5raVKy+yak97MaLcHA==
X-Received: by 2002:a7b:cc82:: with SMTP id p2mr32473wma.120.1625235695947;
        Fri, 02 Jul 2021 07:21:35 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-112-171.dyn.eolo.it. [146.241.112.171])
        by smtp.gmail.com with ESMTPSA id e8sm3493358wrq.10.2021.07.02.07.21.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jul 2021 07:21:35 -0700 (PDT)
Message-ID: <d8061b19ec2a8123d7cf69dad03f1250a5b03220.camel@redhat.com>
Subject: Re: [regression] UDP recv data corruption
From:   Paolo Abeni <pabeni@redhat.com>
To:     Matthias Treydte <mt@waldheinz.de>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     David Ahern <dsahern@gmail.com>, stable@vger.kernel.org,
        netdev@vger.kernel.org, regressions@lists.linux.dev,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org
Date:   Fri, 02 Jul 2021 16:21:34 +0200
In-Reply-To: <6c6eee2832c658d689895aa9585fd30f54ab3ed9.camel@redhat.com>
References: <20210701124732.Horde.HT4urccbfqv0Nr1Aayuy0BM@mail.your-server.de>
         <38ddc0e8-ba27-279b-8b76-4062db6719c6@gmail.com>
         <CA+FuTSc3POcZo0En3JBqRwq2+eF645_Cs4U-4nBmTs9FvjoVkg@mail.gmail.com>
         <20210702143642.Horde.PFbG3LFNTZ3wp0TYiBRGsCM@mail.your-server.de>
         <6c6eee2832c658d689895aa9585fd30f54ab3ed9.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Fri, 2021-07-02 at 16:06 +0200, Paolo Abeni wrote:
> On Fri, 2021-07-02 at 14:36 +0200, Matthias Treydte wrote:
> > And to answer Paolo's questions from his mail to the list (@Paolo: I'm  
> > not subscribed, please also send to me directly so I don't miss your mail)
> 
> (yup, that is what I did ?!?)
> 
> > > Could you please:
> > > - tell how frequent is the pkt corruption, even a rough estimate of the
> > > frequency.
> > 
> > # journalctl --since "5min ago" | grep "Packet corrupt" | wc -l
> > 167
> > 
> > So there are 167 detected failures in 5 minutes, while the system is receiving
> > at a moderate rate of about 900 pkts/s (according to Prometheus' node exporter
> > at least, but seems about right)

I'm sorry for the high-frequency spamming.

Could you please try the following patch ? (only compile-tested)

I fear some packets may hang in the GRO engine for no reasons.
---
diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index 54e06b88af69..458c888337a5 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -526,6 +526,8 @@ struct sk_buff *udp_gro_receive(struct list_head *head, struct sk_buff *skb,
                if ((!sk && (skb->dev->features & NETIF_F_GRO_UDP_FWD)) ||
                    (sk && udp_sk(sk)->gro_enabled) || NAPI_GRO_CB(skb)->is_flist)
                        pp = call_gro_receive(udp_gro_receive_segment, head, skb);
+               else
+                       goto out;
                return pp;
        }

