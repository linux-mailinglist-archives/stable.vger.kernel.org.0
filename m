Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC89D6B53C6
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 23:05:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231824AbjCJWFZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 17:05:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232281AbjCJWFA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 17:05:00 -0500
X-Greylist: delayed 1800 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 10 Mar 2023 14:03:22 PST
Received: from s1.sapience.com (s1.sapience.com [72.84.236.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8763314221;
        Fri, 10 Mar 2023 14:03:21 -0800 (PST)
Authentication-Results: dkim-srvy7; dkim=pass (Good ed25519-sha256 
   signature) header.d=sapience.com header.i=@sapience.com 
   header.a=ed25519-sha256; dkim=pass (Good 2048 bit rsa-sha256 signature) 
   header.d=sapience.com header.i=@sapience.com header.a=rsa-sha256
Received: from srv8.prv.sapience.com (srv8.prv.sapience.com [10.164.28.13])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (secp384r1) server-digest SHA384)
        (No client certificate requested)
        by s1.sapience.com (Postfix) with ESMTPS id 45F949A0580;
        Fri, 10 Mar 2023 16:08:22 -0500 (EST)
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=sapience.com;
 i=@sapience.com; q=dns/txt; s=dk-ed25519-220413; t=1678482502;
 h=message-id : date : mime-version : subject : to : cc : references :
 from : in-reply-to : content-type : content-transfer-encoding : from;
 bh=4LIzV7BjBDoJaxSPqb0qCE7ewLKmWNnbgjun7jsjWuM=;
 b=/+CkqHys6l8rMtQFtl7j5/jEdvgPvjkWjziTYmpQdattcLy8IGfjSnuBr7HAdCRG3Qdmr
 jkOVqugVvhbgJWdCQ==
ARC-Seal: i=1; a=rsa-sha256; d=sapience.com; s=arc6-rsa-220412; t=1678482502;
        cv=none; b=dgXbrNjb9X/FeDwH/X3UqamfxOFzAgJ8zdQicwv/M42HkL6Bo39thGi2mSzUcWw1oipYdqGMg759eLB5g5zL5Tn2w9aD335Qxs9XMZ254Bjw2sSpYOnliwMJlsmxvv2n/Kuarf9lZXbNlb5eMj6vcxLdlEheZSLHFmfyu9TsasrrNeg3OQm5/KTvUHbXVSkPgYST40VPTRf5Fnw+JlGKNxTmbw7cMzHwCTDkb/Q3FiPLavIGtZmEzl5xMc2UEnl3uABk2Ffs2DZ3OBbMI2AZz9BN+kFQ0T0tZkpt/Y9g9eiLx+9slOnvQQVPbvqenqTJf7KKRrcP0UuvkERIg+WKXg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=sapience.com; s=arc6-rsa-220412;
        t=1678482502; c=relaxed/simple;
        bh=F51x7fOvxs0BdNODisJSWDCL+hfTmIWrQUqeqkDAjG4=;
        h=DKIM-Signature:DKIM-Signature:Message-ID:Date:MIME-Version:
         Subject:Content-Language:To:Cc:References:From:In-Reply-To:
         Content-Type:Content-Transfer-Encoding; b=cPU9Pfa+Rg4kN0Nn6CyD4fQOXinUWkx9KapsgZfYhMpG+Q2Y6QQzrlQ+fK2myWSnZ/Jdvlci9vV0wSIq+pjH9WLn2RWbGcuKu8ofMybkynfWH6WYH+g+p0qj2wGxyTPT5Op7/q248bjJ8+jmr8BkX0ziMjfigkLfRdIFCa5lVV9SUJ33rJTrc73Vvo8auT3zpbi/GWWlqnFMreBxHa9Qxt2SSZYFIeWH37yns4uMEkAlmN8eRlFtbkf0hWfex9rhTgSjc3wV2wvSATOCVR/bLpqAOXvs/DjILms8j30++HuydHu7JQYBA+SlZhhuJ3ysF6H6aHEHNdxBuAQLLpWkFQ==
ARC-Authentication-Results: i=1; arc-srv8.sapience.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sapience.com;
 i=@sapience.com; q=dns/txt; s=dk-rsa-220413; t=1678482502;
 h=message-id : date : mime-version : subject : to : cc : references :
 from : in-reply-to : content-type : content-transfer-encoding : from;
 bh=4LIzV7BjBDoJaxSPqb0qCE7ewLKmWNnbgjun7jsjWuM=;
 b=Wr75IauFj6eWLy4hMzmHMajdpG4IhxIsKwLqSmqmckN/Y4ANtX5MkkY1BjI0gnTtUOBEU
 KqfJYoJCEksmBO+y0z3xXV2t/DHILODxvAuMznESWuuXR3OYCow1R1PdQICHzjCB1hyGWRZ
 MQR5bwls4cMzyju1/G94MEIIcYCtZbOnjiftH6WoFiGShnMIHghRea5bMpU3nRR+DCySHoh
 8R6MbiyP/DEGpY5yRXtcS8ALrV1NfICCBOLppUX4olp5CamnbbCfH16AoTvSBB31bbuYJRW
 S5GjQk0ZyEALFdnAoXUT2vj+DL/wuERHGvyWZRon8yhxTRYbwdHuMMIlMTkQ==
Message-ID: <88b36c03-780f-61a5-4a66-e69072aa7536@sapience.com>
Date:   Fri, 10 Mar 2023 16:08:21 -0500
MIME-Version: 1.0
Subject: Re: Possible kernel fs block code regression in 6.2.3 umounting usb
 drives
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, Eric Biggers <ebiggers@kernel.org>,
        Mike Cloaked <mike.cloaked@gmail.com>
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Yu Kuai <yukuai3@huawei.com>
References: <CAOCAAm7AEY9tkZpu2j+Of91fCE4UuE_PqR0UqNv2p2mZM9kqKw@mail.gmail.com>
 <CAOCAAm4reGhz400DSVrh0BetYD3Ljr2CZen7_3D4gXYYdB4SKQ@mail.gmail.com>
 <ZAuPkCn49urWBN5P@sol.localdomain> <ZAuQOHnfa7xGvzKI@sol.localdomain>
 <ad021e89-c05c-f85a-2210-555837473734@kernel.dk>
From:   Genes Lists <lists@sapience.com>
In-Reply-To: <ad021e89-c05c-f85a-2210-555837473734@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/10/23 15:23, Jens Axboe wrote:
> On 3/10/23 1:16 PM, Eric Biggers wrote:
...
> But I would revert:
> 
> bfe46d2efe46c5c952f982e2ca94fe2ec5e58e2a
> 57a425badc05c2e87e9f25713e5c3c0298e4202c
> 
> in that order from 6.2.3 and see if that helps. Adding Yu.
> 
Confirm the 2 Reverts fixed in my tests as well (nvme + sata drives).
Nasty crash - some needed to be power cycled as they hung on shutdown.

Thank you!

gene


