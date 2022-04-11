Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE914FB46C
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 09:15:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245214AbiDKHRx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 03:17:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245213AbiDKHRw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 03:17:52 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 924CD12A84;
        Mon, 11 Apr 2022 00:15:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1649661328;
        bh=RDZvUfwf1irwgubSNfE5Vwdwci+3ZXlMB1TpY03wiyM=;
        h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
        b=i2CXT4XbSy6pOuktI/Y4l5YtfzBHdzAyMzXF2ZcIM3pzbXi2/HXYVi2RP7YCTJBsE
         WRa2pjSEvCQE7Y2mM01WuK4SPzoMXrpN+T9wJWNNrI5Hjqe1Acvinuj7lqgX+ZGGY4
         s8dgLDbg/oE3YeKMSQE/Cqz/3KWxZoV7eYY7hjH0=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([45.77.180.217]) by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MfpSl-1oANvy2i41-00gFJX; Mon, 11
 Apr 2022 09:15:28 +0200
Message-ID: <63cca59f-5962-339c-db9d-c93255962a65@gmx.com>
Date:   Mon, 11 Apr 2022 15:15:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 1/4] btrfs: avoid double clean up when submit_one_bio()
 failed
Content-Language: en-US
To:     Christoph Hellwig <hch@infradead.org>, Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org
References: <cover.1649657016.git.wqu@suse.com>
 <6b8983dd0a3a28155fa7d786bae0a8bf932cdbab.1649657016.git.wqu@suse.com>
 <YlPVQtbeJ9qQVDzg@infradead.org>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
In-Reply-To: <YlPVQtbeJ9qQVDzg@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Cowf8zqqraFyAfUGW92fnrnFu8VpVN32FeomdnlCP8rOyTi/qC6
 9F4mnkSI1qS6tKpppLBCdaBTIze66eRn0HXms4kgIR0UFNOfg2Q4aBBfUDC3A1c1lBYW9xt
 VK6+rP4uZ39XdRXkVYx3A7/Qqi4A93dvhD+8f1/zYfo/aODocFLsH37+wrm5mc5dzAI6Llf
 ac1keP0wJBqjiDzg5HzFA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:9DNnUz+jNCg=:fif1XCwVN4rgdJJnoj5Jf6
 W/1/72WX9ZzN6HHKvSlPZluRW74T1JOpXfWNZ3YLYSf0Et65VzptG3uEBOg+NFOJNxu7QJZN6
 LCO0lsskOMHH4DZ5BldHRBMwPRQHtv0Re90aYdiq0d/+g2bSwQWhyqmqsUNynSxLAqOdrctjA
 r2/VFInIDXoD6hoa4SQUllFGKLGo2tr5e26evE1qx+0h4b5gHjgdU9DGbzYiqdmbl35ere6Dh
 Ajv3YsM3keoS8+A8UIkO1EYoUBEXVG7Zts0rgsp3ymYGSPLowNjxajdj1nZiabV3ItfnY0CeP
 imrdCOEOgk1kPyzpguT4+/plYF/lXzT2tI4JN6/8HR2vr6bm8wn+vrFE+mMDWRVYRN/oZCI2X
 ypxEa+zPaOZAQbg+TKFGYZAwANVG3XLR2bLL5dZ8lW6iMI49656P9bB4TPTTcr91a2VsmmtuL
 eat4p204ELggkJkI1tDddmUKIjadMpslCf5G6qIWVldCDR1YX+T8gLhtganwB5SR4KxinCcN5
 AioV9h4Pnav7DUHYxqBJ7g56fz7Su3r27eHzaoEkXcQXNuT6SDC34GweVcIN8c+QlSYRmzwjJ
 9DPRmDfWL+Q3hlhlUuegPAIKSgryazn6/q8M3IojgI8JSQYAsI7fOJif6r6ZokVTYRBWdj2ym
 kIjwJiIkBR3fiwyCk2vEat3DjcfM8CZsjqRv5GknvXmesC6cPp6v1D1eLUd+rQO9mab0PrcHX
 /fTXmFaI45SuWe42yPNkgJAUJp/0tiT+ODXRndSmHidTeETyA+SIkafzJ8IHhNKBNmc8c4XkW
 m47uZAE8BvYgfFHDEzh8W2g533Id2rvu7Pf50Gv29DRd4Q8h6bqaiMGzdR+jkt8kOTbIrEcP6
 lp+rxjm/3ayrkCSOmqPyiY7OdVgzU0EVcJLHW1Ay9HCsJNbYDQNIU6DPCJrqw3NV77CFdciKW
 6biMZcjtwPHXNLaAsRv7MLLo3czdKbG2TY4uSIAtiNsnVRvYNWUPKm0HHlFyzNnim7rDFOJl1
 0DRFE9aKjEyWrihZ/I6xaSn/YVpzRI6qzWXszhStQWDdEbByWo+l6KIZK1AVHMyoX2LYM1m7l
 hhvScv6fvYXlbc=
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2022/4/11 15:14, Christoph Hellwig wrote:
> On Mon, Apr 11, 2022 at 02:12:49PM +0800, Qu Wenruo wrote:
>> +	/*
>> +	 * Above submission hooks will handle the error by ending the bio,
>> +	 * which will do the cleanup properly.
>> +	 * So here we should not return any error, or the caller of
>> +	 * submit_extent_page() will do cleanup again, causing problems.
>> +	 */
>> +	return 0;
>
> This should not return anything.  Similar to how e.g. submit_bio
> works it needs to be a void return.  And yes, that will properly
> fix all the double completion issues.

Yes, check the last patch.

This patch itself is for backport, thus I didn't change the return type
to make backport easier.

Thanks,
Qu
