Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2300C1E04CE
	for <lists+stable@lfdr.de>; Mon, 25 May 2020 04:44:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388422AbgEYCoi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 May 2020 22:44:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388409AbgEYCoi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 May 2020 22:44:38 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F0F4C061A0E;
        Sun, 24 May 2020 19:44:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=ANukTnGf9qzAoLJoJyRWxzKKdZWe8nKT7t7/i4XYDHs=; b=Y5HnZg8QP8DTAs73j/nJCk8wlu
        wiu8LaYgIfJac8zqjI0xHJgeZ/i7B4788vRf3XmhSqsa0TwgkMagM3TRUM7Kwz24yQV7uq/6wAL8f
        pLZBKbXyaQnAtG8pCoqqMzG1eY8XAZLRRJ/ji6P4yr6LyhvlixgM0HDHZuxgPWdosFQG6L46ejkUX
        RD4S3qgop3rBJVuOMvKLpkqE0yKwqiuGpGADLidqUHHqTcwRtOz9/rl2E2aH5mLNe5VvdTOsw7ikC
        bmI6Fviwh+poEMANipihvbvVk5raZNASVV0nXwzHOIanyVOW8HLt1i6mkrW8+RMV14jT+0vWV+7Am
        HCbGhKUQ==;
Received: from [2601:1c0:6280:3f0::19c2]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jd36A-00004r-Bc; Mon, 25 May 2020 02:44:19 +0000
Subject: Re: [PATCH 1/2] software node: implement software_node_unregister()
To:     Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        kernel test robot <rong.a.chen@intel.com>,
        stable <stable@vger.kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Brendan Higgins <brendanhiggins@google.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Petr Mladek <pmladek@suse.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
References: <20200524153041.2361-1-gregkh@linuxfoundation.org>
 <605c47b7-9199-85f1-89e0-bd768acd3d2d@roeck-us.net>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <13de8a28-9ea9-bf44-c4e7-d5bfb63c81fd@infradead.org>
Date:   Sun, 24 May 2020 19:44:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <605c47b7-9199-85f1-89e0-bd768acd3d2d@roeck-us.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/24/20 9:43 AM, Guenter Roeck wrote:
> On 5/24/20 8:30 AM, Greg Kroah-Hartman wrote:
>> Sometimes it is better to unregister individual nodes instead of trying
>> to do them all at once with software_node_unregister_nodes(), so create
>> software_node_unregister() so that you can unregister them one at a
>> time.
>>
>> This is especially important when creating nodes in a hierarchy, with
>> parent -> children representations.  Children always need to be removed
>> before a parent is, as the swnode logic assumes this is going to be the
>> case.
>>
>> Fix up the lib/test_printf.c fwnode_pointer() test which to use this new
>> function as it had the problem of tearing things down in the backwards
>> order.
>>
>> Fixes: f1ce39df508d ("lib/test_printf: Add tests for %pfw printk modifier")
>> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
>> Reported-by: kernel test robot <rong.a.chen@intel.com>
>> Cc: stable <stable@vger.kernel.org>
>> Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>> Cc: Brendan Higgins <brendanhiggins@google.com>
>> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
>> Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>
>> Cc: Petr Mladek <pmladek@suse.com>
>> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>> Cc: Randy Dunlap <rdunlap@infradead.org>
>> Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
>> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
>> Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
>> Cc: Steven Rostedt <rostedt@goodmis.org>
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> Both patches pass my boot tests on arm64 and arm64be (I didn't test any others).
> So, FWIW,
> 
> Tested-by: Guenter Roeck <linux@roeck-us.net>
> 
> I wasn't sure it the two patches replace or fix commit 4ef12f719802 ("kobject:
> Make sure the parent does not get released before its children"), so I tried
> to re-apply 4ef12f719802 on top of the two patches. Unfortunately that still
> results in crashes and UAF messages.

Yes, that kobject patch has been reverted:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=e6764aa0e5530066dd969eccea2a1a7d177859a8

and these 2 patches are to be used instead.

thanks.
-- 
~Randy

