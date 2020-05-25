Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 328291E0850
	for <lists+stable@lfdr.de>; Mon, 25 May 2020 09:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbgEYH7m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 May 2020 03:59:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:43520 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725809AbgEYH7m (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 May 2020 03:59:42 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 86059B1B4;
        Mon, 25 May 2020 07:59:42 +0000 (UTC)
Date:   Mon, 25 May 2020 09:59:38 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, linux@roeck-us.net,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        kernel test robot <rong.a.chen@intel.com>,
        stable <stable@vger.kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Brendan Higgins <brendanhiggins@google.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 1/2] software node: implement software_node_unregister()
Message-ID: <20200525075937.GA5300@linux-b0ei>
References: <20200524153041.2361-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200524153041.2361-1-gregkh@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun 2020-05-24 17:30:40, Greg Kroah-Hartman wrote:
> Sometimes it is better to unregister individual nodes instead of trying
> to do them all at once with software_node_unregister_nodes(), so create
> software_node_unregister() so that you can unregister them one at a
> time.
> 
> This is especially important when creating nodes in a hierarchy, with
> parent -> children representations.  Children always need to be removed
> before a parent is, as the swnode logic assumes this is going to be the
> case.
> 
> Fix up the lib/test_printf.c fwnode_pointer() test which to use this new
> function as it had the problem of tearing things down in the backwards
> order.
> 
> Fixes: f1ce39df508d ("lib/test_printf: Add tests for %pfw printk modifier")
> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> Reported-by: kernel test robot <rong.a.chen@intel.com>
> Cc: stable <stable@vger.kernel.org>
> Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: Brendan Higgins <brendanhiggins@google.com>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> Cc: Petr Mladek <pmladek@suse.com>
> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

I could confirm that this fixed lib/test_printf.c. The patch looks reasonable.

Tested-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr
