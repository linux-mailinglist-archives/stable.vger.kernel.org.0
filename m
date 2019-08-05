Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B4EB810CB
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 06:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726045AbfHEERb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 00:17:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55776 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725782AbfHEERb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 00:17:31 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A5A373082A49;
        Mon,  5 Aug 2019 04:17:30 +0000 (UTC)
Received: from [10.72.12.115] (ovpn-12-115.pek2.redhat.com [10.72.12.115])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4087B5D9E2;
        Mon,  5 Aug 2019 04:17:22 +0000 (UTC)
Subject: Re: [PATCH 4.19 21/32] vhost_net: fix possible infinite loop
To:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
References: <20190802092101.913646560@linuxfoundation.org>
 <20190802092108.665019390@linuxfoundation.org> <20190803214930.GB22416@amd>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <8ccb9b02-2dbd-4e80-3d55-998fb1045446@redhat.com>
Date:   Mon, 5 Aug 2019 12:17:21 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190803214930.GB22416@amd>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Mon, 05 Aug 2019 04:17:30 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 2019/8/4 上午5:49, Pavel Machek wrote:
> Hi!
>
>> This makes it possible to trigger a infinite while..continue loop
>> through the co-opreation of two VMs like:
>>
>> 1) Malicious VM1 allocate 1 byte rx buffer and try to slow down the
>>     vhost process as much as possible e.g using indirect descriptors or
>>     other.
>> 2) Malicious VM2 generate packets to VM1 as fast as possible
>>
>> Fixing this by checking against weight at the end of RX and TX
>> loop. This also eliminate other similar cases when:
>>
>> - userspace is consuming the packets in the meanwhile
>> - theoretical TOCTOU attack if guest moving avail index back and forth
>>    to hit the continue after vhost find guest just add new buffers
>>
>> This addresses CVE-2019-3900.
>>
>> @@ -551,7 +551,7 @@ static void handle_tx_copy(struct vhost_
>>   	int err;
>>   	int sent_pkts = 0;
>>   
>> -	for (;;) {
>> +	do {
>>   		bool busyloop_intr = false;
>>   
>>   		head = get_tx_bufs(net, nvq, &msg, &out, &in, &len,
>> @@ -592,9 +592,7 @@ static void handle_tx_copy(struct vhost_
>>   				 err, len);
>>   		if (++nvq->done_idx >= VHOST_NET_BATCH)
>>   			vhost_net_signal_used(nvq);
>> -		if (vhost_exceeds_weight(vq, ++sent_pkts, total_len))
>> -			break;
>> -	}
>> +	} while (likely(!vhost_exceeds_weight(vq, ++sent_pkts, total_len)));
>>   
>>   	vhost_net_signal_used(nvq);
>>   }
> So this part does not really change anything, right?


Nope, if you check the loop you can see we used to use "continue" inside 
the loop which may bypass the check:


         head = get_tx_bufs(net, nvq, &msg, &out, &in, &len,
                    &busyloop_intr);
         /* On error, stop handling until the next kick. */
         if (unlikely(head < 0))
             break;
         /* Nothing new?  Wait for eventfd to tell us they refilled. */
         if (head == vq->num) {
             if (unlikely(busyloop_intr)) {
                 vhost_poll_queue(&vq->poll);
             } else if (unlikely(vhost_enable_notify(&net->dev,
                                 vq))) {
                 vhost_disable_notify(&net->dev, vq);
                 continue;
             }
             break;
         }


>
>> @@ -618,7 +616,7 @@ static void handle_tx_zerocopy(struct vh
>>   	bool zcopy_used;
>>   	int sent_pkts = 0;
>>   
>> -	for (;;) {
>> +	do {
>>   		bool busyloop_intr;
>>   
>>   		/* Release DMAs done buffers first */
>> @@ -693,10 +691,7 @@ static void handle_tx_zerocopy(struct vh
>>   		else
>>   			vhost_zerocopy_signal_used(net, vq);
>>   		vhost_net_tx_packet(net);
>> -		if (unlikely(vhost_exceeds_weight(vq, ++sent_pkts,
>> -						  total_len)))
>> -			break;
>> -	}
>> +	} while (likely(!vhost_exceeds_weight(vq, ++sent_pkts, total_len)));
>>   }
>>   
>>   /* Expects to be always run from workqueue - which acts as
> Neither does this. Equivalent code. Changelog says it fixes something
> for the transmit so... is that intentional?
>
> 									Pavel


The same as above. So yes.

Thanks

