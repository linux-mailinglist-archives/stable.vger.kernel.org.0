Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 354D21E1862
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 02:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbgEZAMk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 May 2020 20:12:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725969AbgEZAMj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 May 2020 20:12:39 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72DC5C061A0E;
        Mon, 25 May 2020 17:12:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=2gQXzxPn1mcNo1x+VTCevyXqO93PV22DXQ1XG6KVVyQ=; b=EeM0kRyNn6m1rpzWGVTQEZL16R
        KI/rxRWfNVgyHfJq9XVRq/pcD8Bx3sIsUwFlLL4OdEqy7C8z9337XfVl5QCBzCkhpiQgwDNjPBSN1
        pXbmrtV+pdlsatWa8vtpmKTdwFKUeEnlGc2XjPu+cVxbP86+atTxvqw0n+7cEkxnmypfgT1773Tx/
        vitFLSjl2BS5IjIbP+ynV1pGEo2Tgt/skSfoU8ue4aLw9PHq+Y1zjVF8nZ5cdv3PGkACwf+sCL6wA
        fUBQwc7Y1mMWgyzcpmq+CYzYTVYLeJ7eA/2OO82tO+esywnErfDqlNC9NK6l9Nvdx0UW+IszliCor
        jhtNd5kQ==;
Received: from [2601:1c0:6280:3f0::19c2]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jdNCa-000459-9l; Tue, 26 May 2020 00:12:16 +0000
Subject: Re: [PATCH 1/2] software node: implement software_node_unregister()
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     linux@roeck-us.net, Naresh Kamboju <naresh.kamboju@linaro.org>,
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
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <232ef951-e20d-0c7c-a8a2-7c4fa910fa8a@infradead.org>
Date:   Mon, 25 May 2020 17:12:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200524153041.2361-1-gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/24/20 8:30 AM, Greg Kroah-Hartman wrote:
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

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org>

thanks.

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
> 


-- 
~Randy
