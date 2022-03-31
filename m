Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39DB24ED2A7
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 06:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230430AbiCaE23 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 00:28:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230330AbiCaE2M (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 00:28:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E4F64E3BF;
        Wed, 30 Mar 2022 21:22:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E25D61025;
        Thu, 31 Mar 2022 04:22:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66408C340ED;
        Thu, 31 Mar 2022 04:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648700542;
        bh=s4M7wVdLPAyGUQgwQFXe+kU1TwGw128GrBH3ZFT9AmE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0Yor86GTNke4Hub5PNKbDznchBzHE9kfVg9ZG+n/sR2JvXS5IK0+w+rsd3rEmqJk3
         RGBkVjv+Z3Wh3Lds5nIM/mFQb7BwbFKurr0/WM82WrgFKtuAkQ3MGz92OpIeVksBam
         QnIMGsziQ0KHg1FReB1ZKkJ7sgSVtplPsnrdjf88=
Date:   Thu, 31 Mar 2022 06:22:19 +0200
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     =?utf-8?B?7KGw7KSA7JmE?= <junwan.cho@samsung.com>
Cc:     Krzysztof Kozlowski <krzk@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        "michael.zaidman@gmail.com" <michael.zaidman@gmail.com>,
        "erazor_de@users.sourceforge.net" <erazor_de@users.sourceforge.net>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        =?utf-8?B?6rmA7J287Zi4?= <ih0923.kim@samsung.com>,
        =?utf-8?B?67CV7LKc7Zi4?= <chun.ho.park@samsung.com>,
        =?utf-8?B?67Cw7Jyk7Iud?= <yunsik.bae@samsung.com>,
        =?utf-8?B?6rCV64yA7Z2s?= <daihee7.kang@samsung.com>,
        =?utf-8?B?7J206rSR7Zi4?= <gaudium.lee@samsung.com>,
        =?utf-8?B?66WY7LKc7Jqw?= <chunwoo.ryu@samsung.com>,
        =?utf-8?B?64KY65GQ7IiY?= <doosu.na@samsung.com>,
        =?utf-8?B?6rmA7IiY7ZiE?= <suhyun_.kim@samsung.com>
Subject: Re: (2) Request for reverting the commit for Samsung HID driver
Message-ID: <YkUse2wQibmLzE+m@kroah.com>
References: <20220330070159epcms1p31c351bc7eb90d99e0bbecd2c2f6092d1@epcms1p3>
 <20220330080937epcms1p51e6c98c5eb5f8108c9cfe35efa450daa@epcms1p5>
 <20220330082308epcms1p3f9bb275272b3e32abd4202fa1b893623@epcms1p3>
 <20220330084401epcms1p1fe9efa50452a84f7bbb22a4de82b5a0a@epcms1p1>
 <20220330090150epcms1p42e28758b515942ecdee680cdef3ef0b9@epcms1p4>
 <20220330092058epcms1p799e10561617c02a14d5d8b413722f678@epcms1p7>
 <20220330094354epcms1p282a35cfc39cea0b76125387a496d9284@epcms1p2>
 <20220330095806epcms1p34fa55d36ed5ce200fb74a9a23aa279a5@epcms1p3>
 <CGME20220330062122epcms1p30a2c2e3e1d3b108d729a00034bf86587@epcms1p4>
 <20220331015105epcms1p404df5e500988fca3aeabcc2e05cb172e@epcms1p4>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220331015105epcms1p404df5e500988fca3aeabcc2e05cb172e@epcms1p4>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 31, 2022 at 10:51:05AM +0900, 조준완 wrote:
> If bottom posting is natural, why doesn't our mailing system support bottom positing?

Mine does, perhaps you need a better email client?

> It's not clear which method is more efficient. Still a lot of people are arguing which is the most effective way.
> I don't want to scroll down to read your reply.
> Don't force it on others.

Sorry, but that is the Linux kernel development style, and has been for
20+ years.  Again, see these links for why:

	http://en.wikipedia.org/wiki/Top_post
	http://daringfireball.net/2007/07/on_top

> I have simply sent an inquiry email, and you only need to respond to it.

And we did, and asked you nicely to perhaps use a better format to
discuss technical things easier.

> I didn't write a tech thread. This is a kind of business mail. 

This is not a business :)

Good luck!

greg k-h
