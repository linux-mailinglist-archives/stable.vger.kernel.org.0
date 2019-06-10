Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6375E3AFEE
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 09:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388018AbfFJHsn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jun 2019 03:48:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:35508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388005AbfFJHsn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Jun 2019 03:48:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01F9F206E0;
        Mon, 10 Jun 2019 07:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560152922;
        bh=KvIm6HtouftqCTee6FSb1zeL3AYFpzbI2I9FwwofGXI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=V71pFYS9DZUK2y/72BBDM8kVV74UOhvwjsOuaZ4VZLLHfqr5ZoTJN1fP4OYwMzjTt
         NZ12gOEAB/QY8SfMQVObGvhB+Pk+fRvU9OOHJdAzqg7vyBhSB0CV/6uXFpSSOWHqSu
         AM6wlL541OocdIg7D5fb0tLJ0L8vlbfgN6rEaujc=
Date:   Mon, 10 Jun 2019 09:48:40 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jiri Slaby <jslaby@suse.cz>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH 5.1 56/85] doc: Cope with the deprecation of AutoReporter
Message-ID: <20190610074840.GB24746@kroah.com>
References: <20190607153849.101321647@linuxfoundation.org>
 <20190607153855.717899507@linuxfoundation.org>
 <1fbb40df-d420-9f10-34a9-340b3156eb7c@suse.cz>
 <20190610073119.GB20470@kroah.com>
 <f20b3005-53f8-607a-e995-741836b3f5f0@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f20b3005-53f8-607a-e995-741836b3f5f0@suse.cz>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 10, 2019 at 09:34:10AM +0200, Jiri Slaby wrote:
> On 10. 06. 19, 9:31, Greg Kroah-Hartman wrote:
> > On Mon, Jun 10, 2019 at 08:27:30AM +0200, Jiri Slaby wrote:
> >> On 07. 06. 19, 17:39, Greg Kroah-Hartman wrote:
> >>> From: Jonathan Corbet <corbet@lwn.net>
> >>>
> >>> commit 2404dad1f67f8917e30fc22a85e0dbcc85b99955 upstream.
> >>>
> >>> AutoReporter is going away; recent versions of sphinx emit a warning like:
> >>>
> >>>   Documentation/sphinx/kerneldoc.py:125:
> >>>       RemovedInSphinx20Warning: AutodocReporter is now deprecated.
> >>>       Use sphinx.util.docutils.switch_source_input() instead.
> >>>
> >>> Make the switch.  But switch_source_input() only showed up in 1.7, so we
> >>> have to do ugly version checks to keep things working in older versions.
> >>
> >> Hi,
> >>
> >> this patch breaks our build of kernel-docs on 5.1.*:
> >> https://build.opensuse.org/package/live_build_log/Kernel:stable/kernel-docs/standard/x86_64
> >>
> >> The error is:
> >> [  250s] reST markup error:
> >> [  250s]
> >> /home/abuild/rpmbuild/BUILD/kernel-docs-5.1.8/linux-5.1/Documentation/gpu/i915.rst:403:
> >> (SEVERE/4) Title level inconsistent:
> >> [  250s]
> >> [  250s] Global GTT Fence Handling
> >> [  250s] ~~~~~~~~~~~~~~~~~~~~~~~~~
> >>
> >> Reverting the patch from 5.1.* makes it work again.
> >>
> >> 5.2-rc3 (includes the patch) is OK:
> >> https://build.opensuse.org/package/live_build_log/Kernel:HEAD/kernel-docs/standard/x86_64
> >>
> >> So 5.1.* must be missing something now.
> > 
> > Odd.  running 'make htmldocs' on 5.1 with these patches applied works
> > for me here.
> > 
> > What version of sphinx are you using to build the package with?
> 
> >From the log, it looks like 1.8.5 (it's tumbleweed):
> 
> $ osc rbl Kernel:stable/kernel-docs/standard/x86_64|grep -i sphinx
> [   11s] cycle: python3-sphinx_rtd_theme -> python3-Sphinx
> [   11s]   breaking dependency python3-Sphinx -> python3-sphinx_rtd_theme
> [   32s] [226/263] cumulate python3-sphinxcontrib-websupport-1.1.0-1.2
> [   32s] [239/263] cumulate python3-Sphinx-1.8.5-2.2
> [   32s] [242/263] cumulate python3-sphinx_rtd_theme-0.4.1-1.3
> [   72s]
> python3-sphinxcontrib-websupport-1.1.0########################################
> [   72s] python3-sphinx_rtd_theme-0.4.1-1.3
> ########################################
> [   73s] python3-Sphinx-1.8.5-2.2
> ########################################
> [   73s] update-alternatives: using /usr/bin/sphinx-apidoc-3.7 to
> provide /usr/bin/sphinx-apidoc (sphinx-apidoc) in auto mode
> [  101s] + patch -s -F0 -E -p1 --no-backup-if-mismatch -i
> /home/abuild/rpmbuild/BUILD/kernel-docs-5.1.8/patches.kernel.org/5.1.8-055-docs-Fix-conf.py-for-Sphin-2.0.patch
> [  101s] + patch -s -F0 -E -p1 --no-backup-if-mismatch -i
> /home/abuild/rpmbuild/BUILD/kernel-docs-5.1.8/patches.kernel.org/5.1.8-057-doc-Cope-with-Sphinx-logging-deprecations.patch
> [  102s]   SPHINX  htmldocs -->
> file:///home/abuild/rpmbuild/BUILD/kernel-docs-5.1.8/linux-5.1/html/Documentation/output
> [  103s] Running Sphinx v1.8.5

Hm, 2.1 here:
	Running Sphinx v2.1.0
perhaps Tumbleweed needs to update?  :)

Anyway, this should not be breaking, if Jon doesn't have any ideas, I'll
just drop these changes.

thanks,

greg k-h
