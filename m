Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE9D46C4F8
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 04:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727847AbfGRC3N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 22:29:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:46204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727787AbfGRC3N (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 22:29:13 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4E5420693;
        Thu, 18 Jul 2019 02:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563416952;
        bh=2al5dDB1QGuCWB3Crm/8rt8z8AxFdOWfnkgmI4UzPSc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PU/9ZjOIjOfP/JFyzI5gfIjK6E62q03dwuuvLF2mL1b+ZBi3Tkg1MajanCgM/uVEG
         e+LyDtZ/Tr8sO60aevE5G5MgcPIiLeMk6TuIFZyLSa141UgiOiobEl5AyHJwY8Uuyr
         Lz3uaee2o4zEAnjP69PTvk7SRKwSmJ6zIlF83MfY=
Date:   Thu, 18 Jul 2019 11:29:09 +0900
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     linux-nvdimm@lists.01.org, "Rafael J. Wysocki" <rafael@kernel.org>,
        stable@vger.kernel.org, Jane Chu <jane.chu@oracle.com>,
        peterz@infradead.org, vishal.l.verma@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/7] drivers/base: Introduce kill_device()
Message-ID: <20190718022909.GB15376@kroah.com>
References: <156341206785.292348.1660822720191643298.stgit@dwillia2-desk3.amr.corp.intel.com>
 <156341207332.292348.14959761496009347574.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156341207332.292348.14959761496009347574.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 17, 2019 at 06:07:53PM -0700, Dan Williams wrote:
> The libnvdimm subsystem arranges for devices to be destroyed as a result
> of a sysfs operation. Since device_unregister() cannot be called from
> an actively running sysfs attribute of the same device libnvdimm
> arranges for device_unregister() to be performed in an out-of-line async
> context.
> 
> The driver core maintains a 'dead' state for coordinating its own racing
> async registration / de-registration requests. Rather than add local
> 'dead' state tracking infrastructure to libnvdimm device objects, export
> the existing state tracking via a new kill_device() helper.
> 
> The kill_device() helper simply marks the device as dead, i.e. that it
> is on its way to device_del(), or returns that the device was already
> dead. This can be used in advance of calling device_unregister() for
> subsystems like libnvdimm that might need to handle multiple user
> threads racing to delete a device.
> 
> This refactoring does not change any behavior, but it is a pre-requisite
> for follow-on fixes and therefore marked for -stable.
> 
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: "Rafael J. Wysocki" <rafael@kernel.org>
> Fixes: 4d88a97aa9e8 ("libnvdimm, nvdimm: dimm driver and base libnvdimm device-driver...")
> Cc: <stable@vger.kernel.org>
> Tested-by: Jane Chu <jane.chu@oracle.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
