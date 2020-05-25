Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EFF11E0CC1
	for <lists+stable@lfdr.de>; Mon, 25 May 2020 13:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390100AbgEYLYQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 May 2020 07:24:16 -0400
Received: from mga06.intel.com ([134.134.136.31]:56855 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389897AbgEYLYP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 May 2020 07:24:15 -0400
IronPort-SDR: p9kcU0T3xNHo0KdbTel4/+N0dwKt0kjS890xUNniRU9OGnoMO4Dh4eLgNHHdjD0OvI1Ck006dp
 onrcCXulMJYw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2020 04:24:15 -0700
IronPort-SDR: SQzU8SMO4DVlsQEdL7JernjBzFrgFoakWQ+ufSXtU/D+i3RaC/pGLFQubeq2AeHeO5DpQ/EenL
 pBd1vtj9mOyQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,433,1583222400"; 
   d="scan'208";a="375411545"
Received: from kuha.fi.intel.com ([10.237.72.162])
  by fmsmga001.fm.intel.com with SMTP; 25 May 2020 04:24:10 -0700
Received: by kuha.fi.intel.com (sSMTP sendmail emulation); Mon, 25 May 2020 14:24:09 +0300
Date:   Mon, 25 May 2020 14:24:09 +0300
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, linux@roeck-us.net,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        kernel test robot <rong.a.chen@intel.com>,
        stable <stable@vger.kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Brendan Higgins <brendanhiggins@google.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Petr Mladek <pmladek@suse.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 1/2] software node: implement software_node_unregister()
Message-ID: <20200525112409.GA3208393@kuha.fi.intel.com>
References: <20200524153041.2361-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200524153041.2361-1-gregkh@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, May 24, 2020 at 05:30:40PM +0200, Greg Kroah-Hartman wrote:
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

FWIW:

Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>

> ---
>  drivers/base/swnode.c    | 27 +++++++++++++++++++++------
>  include/linux/property.h |  1 +
>  lib/test_printf.c        |  4 +++-
>  3 files changed, 25 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/base/swnode.c b/drivers/base/swnode.c
> index de8d3543e8fe..770b1f47a625 100644
> --- a/drivers/base/swnode.c
> +++ b/drivers/base/swnode.c
> @@ -712,17 +712,18 @@ EXPORT_SYMBOL_GPL(software_node_register_nodes);
>   * @nodes: Zero terminated array of software nodes to be unregistered
>   *
>   * Unregister multiple software nodes at once.
> + *
> + * NOTE: Be careful using this call if the nodes had parent pointers set up in
> + * them before registering.  If so, it is wiser to remove the nodes
> + * individually, in the correct order (child before parent) instead of relying
> + * on the sequential order of the list of nodes in the array.
>   */
>  void software_node_unregister_nodes(const struct software_node *nodes)
>  {
> -	struct swnode *swnode;
>  	int i;
>  
> -	for (i = 0; nodes[i].name; i++) {
> -		swnode = software_node_to_swnode(&nodes[i]);
> -		if (swnode)
> -			fwnode_remove_software_node(&swnode->fwnode);
> -	}
> +	for (i = 0; nodes[i].name; i++)
> +		software_node_unregister(&nodes[i]);
>  }
>  EXPORT_SYMBOL_GPL(software_node_unregister_nodes);
>  
> @@ -741,6 +742,20 @@ int software_node_register(const struct software_node *node)
>  }
>  EXPORT_SYMBOL_GPL(software_node_register);
>  
> +/**
> + * software_node_unregister - Unregister static software node
> + * @node: The software node to be unregistered
> + */
> +void software_node_unregister(const struct software_node *node)
> +{
> +	struct swnode *swnode;
> +
> +	swnode = software_node_to_swnode(node);
> +	if (swnode)
> +		fwnode_remove_software_node(&swnode->fwnode);
> +}
> +EXPORT_SYMBOL_GPL(software_node_unregister);
> +
>  struct fwnode_handle *
>  fwnode_create_software_node(const struct property_entry *properties,
>  			    const struct fwnode_handle *parent)
> diff --git a/include/linux/property.h b/include/linux/property.h
> index d86de017c689..0d4099b4ce1f 100644
> --- a/include/linux/property.h
> +++ b/include/linux/property.h
> @@ -441,6 +441,7 @@ int software_node_register_nodes(const struct software_node *nodes);
>  void software_node_unregister_nodes(const struct software_node *nodes);
>  
>  int software_node_register(const struct software_node *node);
> +void software_node_unregister(const struct software_node *node);
>  
>  int software_node_notify(struct device *dev, unsigned long action);
>  
> diff --git a/lib/test_printf.c b/lib/test_printf.c
> index 6b1622f4d7c2..fc63b8959d42 100644
> --- a/lib/test_printf.c
> +++ b/lib/test_printf.c
> @@ -637,7 +637,9 @@ static void __init fwnode_pointer(void)
>  	test(second_name, "%pfwP", software_node_fwnode(&softnodes[1]));
>  	test(third_name, "%pfwP", software_node_fwnode(&softnodes[2]));
>  
> -	software_node_unregister_nodes(softnodes);
> +	software_node_unregister(&softnodes[2]);
> +	software_node_unregister(&softnodes[1]);
> +	software_node_unregister(&softnodes[0]);
>  }
>  
>  static void __init
> -- 
> 2.26.2

thanks,

-- 
heikki
