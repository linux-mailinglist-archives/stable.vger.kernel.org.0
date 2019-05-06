Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B368114692
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 10:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726094AbfEFIls (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 04:41:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:59896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725851AbfEFIls (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 04:41:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35296205C9;
        Mon,  6 May 2019 08:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557132107;
        bh=t3JV6XuISHMHUjZFjImCY7von2HXibLddJsj/N80ELY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EnR3HkGj5NoW8A/kUS6qQc9HxzmvFgkP2TUGudGjdOCG+LT1cGPoyzPf2zoBnoJgC
         R5DGhgQeO1wpqf0J3v3ypPdtNqOuoCPVwuoHZPccr0mXXl80NQ6w3Z655zl7esKT0c
         rDYTTtWrrBICLEd5/zr47pXYKXaTv0G2l0yF/g/U=
Date:   Mon, 6 May 2019 10:41:45 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Paul Gortmaker <paul.gortmaker@windriver.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc:     stable@vger.kernel.org, Erik Schmauss <erik.schmauss@intel.com>
Subject: Re: Possible mis-backport of 4abb951b in 4.19.35 ("ACPICA: AML
 interpreter: add region addresses...")
Message-ID: <20190506084145.GA23991@kroah.com>
References: <20190505194448.GA2649@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190505194448.GA2649@windriver.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, May 05, 2019 at 03:44:48PM -0400, Paul Gortmaker wrote:
> I noticed 4.19.35 got a backport of mainline 4abb951b, but it appears to
> be a duplicate backport that landed in the wrong function.  We can see
> this in the stable-queue repo:
> 
> stable-queue$ find . -name '*acpica-aml-interpreter-add-region-addr*' |grep 4.19
> ./releases/4.19.6/acpica-aml-interpreter-add-region-addresses-in-global-list-during-initialization.patch
> ./releases/4.19.3/revert-acpica-aml-interpreter-add-region-addresses-in.patch
> ./releases/4.19.35/acpica-aml-interpreter-add-region-addresses-in-global-list-during-initialization.patch
> ./releases/4.19.2/acpica-aml-interpreter-add-region-addresses-in-global-list-during-initialization.patch
> 
> So it was added to 4.19.2, reverted in .3, re-added in .6, and then
> finally patched into a similar looking but wrong function in .35
> 
> If we diff the .6 and .35 versions, we see the function difference:
> 
> -@@ -417,6 +417,10 @@ acpi_ds_eval_region_operands(struct acpi
> +@@ -523,6 +523,10 @@ acpi_ds_eval_table_region_operands(struc
> 
> I don't know what the history is/was around the 2/3/6 churn, but the
> re-addition in 4.19.35 to a different function sure looks wrong.
> 
> The commit adds a call "status = acpi_ut_add_address_range(..." and if
> we check mainline, there is only one in that file, but in 4.19.35+ there
> now are two calls - since the two functions had similar context and
> comments, it isn't hard to see how patch could/would apply it a 2nd time
> in the wrong place.
> 
> I didn't check if any of the other currently maintained linux-stable
> versions also had this possible issue.
> 

Ugh, Rafael, did I mess this up again?  Can you check to see if I need
to fix this somehow?

thanks,

greg k-h
