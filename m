Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 554A12A284D
	for <lists+stable@lfdr.de>; Mon,  2 Nov 2020 11:31:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728183AbgKBKbx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 05:31:53 -0500
Received: from smtp112.iad3a.emailsrvr.com ([173.203.187.112]:48554 "EHLO
        smtp112.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728156AbgKBKbw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Nov 2020 05:31:52 -0500
X-Greylist: delayed 385 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Nov 2020 05:31:52 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mev.co.uk;
        s=20190130-41we5z8j; t=1604312727;
        bh=1iPAZQdymRK4SMK3HljywvaZpxIg/V54cJQz7Xq3clc=;
        h=Subject:To:From:Date:From;
        b=LdDLn21RTRd75avsOEC78Rdy1cZHBfqoiUy1jHCZwO+gGwkI738bZi9SG6mQhHnOQ
         AkKKXvcRiZJH7j/UKF82rW5vINE/aAsR3+RgDqzWWBH/QkzGl4verYdAMnea0W5P1x
         M0CmJ1MaMo1t6qa04gNWrJ1qSqISGQLAH0D9n00k=
X-Auth-ID: abbotti@mev.co.uk
Received: by smtp23.relay.iad3a.emailsrvr.com (Authenticated sender: abbotti-AT-mev.co.uk) with ESMTPSA id 8730324EDF;
        Mon,  2 Nov 2020 05:25:26 -0500 (EST)
Subject: Re: [PATCH] staging: comedi: cb_pcidas: reinstate delay removed from
 trimpot setting
To:     devel@driverdev.osuosl.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        stable@vger.kernel.org
References: <20201029141833.126856-1-abbotti@mev.co.uk>
From:   Ian Abbott <abbotti@mev.co.uk>
Organization: MEV Ltd.
Message-ID: <3d7cf15a-c389-ec2c-5e29-8838e8466790@mev.co.uk>
Date:   Mon, 2 Nov 2020 10:25:25 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201029141833.126856-1-abbotti@mev.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Classification-ID: 860e8a4e-d374-4e47-a4e7-608e1eb206c8-1-1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 29/10/2020 14:18, Ian Abbott wrote:
> Commit eddd2a4c675c ("staging: comedi: cb_pcidas: refactor
> write_calibration_bitstream()") inadvertently removed one of the
> `udelay(1)` calls when writing to the calibration register in
> `cb_pcidas_calib_write()`.  Reinstate the delay.  It may seem strange
> that the delay is placed before the register write, but this function is
> called in a loop so the extra delay can make a difference.
> 
> This _might_ solve reported issues reading analog inputs on a
> PCIe-DAS1602/16 card where the analog input values "were scaled in a
> strange way that didn't make sense".  On the same hardware running a
> system with a 3.13 kernel, and then a system with a 4.4 kernel, but with
> the same application software, the system with the 3.13 kernel was fine,
> but the one with the 4.4 kernel exhibited the problem.  Of the 90
> changes to the driver between those kernel versions, this change looked
> like the most likely culprit.

Actually, I've realized that this patch will have no effect on the 
PCIe-DAS1602/16 card because it uses a different driver - cb_pcimdas, 
not cb_pcidas.

Greg, you might as well drop this patch if you haven't already applied 
it, since it was only a hunch that it fixed a problem.

-- 
-=( Ian Abbott <abbotti@mev.co.uk> || MEV Ltd. is a company  )=-
-=( registered in England & Wales.  Regd. number: 02862268.  )=-
-=( Regd. addr.: S11 & 12 Building 67, Europa Business Park, )=-
-=( Bird Hall Lane, STOCKPORT, SK3 0XA, UK. || www.mev.co.uk )=-
