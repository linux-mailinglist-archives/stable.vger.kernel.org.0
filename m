Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CADBE38208B
	for <lists+stable@lfdr.de>; Sun, 16 May 2021 21:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231901AbhEPTFG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 May 2021 15:05:06 -0400
Received: from sender4-of-o53.zoho.com ([136.143.188.53]:21310 "EHLO
        sender4-of-o53.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231589AbhEPTFG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 May 2021 15:05:06 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1621191817; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=ia14Lb0T+uAulHG1TPwDesKVhwZdhRTbtZ1b0y/wFBx2A3U72f0n9So09gjvWPRry4CBotf+k7p8fIRTC7a0tWVdkm0/uK7PF8HepVbohc9fhW9e8fk6AWEULZ28bQ6IDqyPWZZiWNk/ngwana0QVKRP2ZArADtqQMtm94t1jU0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1621191817; h=Content-Type:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=knJeWAuAqA5UlEpt83ngR+767zMb5UM/sYg1v7UcpCw=; 
        b=ZuSmqIlCcQVrp9Q6yJBOVJLK8wKdeCqCG3NouE1jX4+S6G3kD076e9taZD3qJPRQA7Is7+un+G4lI/B/13geEiLuqhAn4ZhwHYjY0R2qoVy1McLUC5js/vS4HFjsA2rqR/wB0N2AuOX4lv+Ir1kbBa3zS3WuX5wuCiXxXiNZ+n8=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=anirudhrb.com;
        spf=pass  smtp.mailfrom=mail@anirudhrb.com;
        dmarc=pass header.from=<mail@anirudhrb.com> header.from=<mail@anirudhrb.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1621191817;
        s=zoho; d=anirudhrb.com; i=mail@anirudhrb.com;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:In-Reply-To;
        bh=knJeWAuAqA5UlEpt83ngR+767zMb5UM/sYg1v7UcpCw=;
        b=M6eXNQwysaohb7TkG4TH35wkAaQarDniox+pI1CAHWO5Y4qkxIEN4vpGlIYiOtgX
        pxjhgNXfsfi9vedl4McoQnxei3ZqmFssc8VN8UO/pVlf0GkVyr7JC69TGNO9+b4qm/9
        wks111COXEGC1nBpHkybyphkYG3Iqi5f+OqVD3Y0=
Received: from anirudhrb.com (106.51.110.61 [106.51.110.61]) by mx.zohomail.com
        with SMTPS id 1621191814374210.47511037786865; Sun, 16 May 2021 12:03:34 -0700 (PDT)
Date:   Mon, 17 May 2021 00:33:26 +0530
From:   Anirudh Rayabharam <mail@anirudhrb.com>
To:     kernel test robot <oliver.sang@intel.com>
Cc:     Igor Matheus Andrade Torrente <igormtorrente@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ferenc Bakonyi <fero@drama.obuda.kando.hu>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        stable <stable@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, lkp@lists.01.org,
        lkp@intel.com
Subject: Re: [video]  dc13cac486: BUG:KASAN:stack-out-of-bounds_in_hgafb_open
Message-ID: <YKFsfoaofqs1MQDw@anirudhrb.com>
References: <20210516150019.GB25903@xsang-OptiPlex-9020>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210516150019.GB25903@xsang-OptiPlex-9020>
X-ZohoMailClient: External
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, May 16, 2021 at 11:00:19PM +0800, kernel test robot wrote:
> 
> 
> Greeting,
> 
> FYI, we noticed the following commit (built with gcc-9):
> 
> commit: dc13cac4862cc68ec74348a80b6942532b7735fa ("video: hgafb: fix potential NULL pointer dereference")
> https://git.kernel.org/cgit/linux/kernel/git/gregkh/char-misc.git char-misc-linus
> 
> 
> in testcase: trinity
> version: trinity-static-x86_64-x86_64-f93256fb_2019-08-28
> with following parameters:
> 
> 	number: 99999
> 	group: group-02
> 
> test-description: Trinity is a linux system call fuzz tester.
> test-url: http://codemonkey.org.uk/projects/trinity/
> 
> 
> on test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 16G
> 
> caused below changes (please refer to attached dmesg/kmsg for entire log/backtrace):
> 
> 
> +---------------------------------------------+------------+------------+
> |                                             | 58c0cc2d90 | dc13cac486 |
> +---------------------------------------------+------------+------------+
> | boot_successes                              | 42         | 14         |
> | boot_failures                               | 0          | 34         |
> | BUG:KASAN:stack-out-of-bounds_in_hgafb_open | 0          | 34         |
> +---------------------------------------------+------------+------------+
> 
> 
> If you fix the issue, kindly add following tag
> Reported-by: kernel test robot <oliver.sang@intel.com>
> 
> 
> [  419.568887] BUG: KASAN: stack-out-of-bounds in hgafb_open (kbuild/src/consumer/drivers/video/fbdev/hgafb.c:375) 

Looks like the return value of hga_card_detect() is not properly
handled causing the probe function to succeed even though
hga_card_detect() has failed. Since probe has succeeded, hgafb_open()
can be called which will end up operating on an unmapped hga_vram.

Patch on the way.

Thanks!

	- Anirudh.
