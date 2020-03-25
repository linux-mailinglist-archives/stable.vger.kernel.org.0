Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 925D8192E50
	for <lists+stable@lfdr.de>; Wed, 25 Mar 2020 17:38:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725812AbgCYQi0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Mar 2020 12:38:26 -0400
Received: from aer-iport-2.cisco.com ([173.38.203.52]:39205 "EHLO
        aer-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727275AbgCYQi0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Mar 2020 12:38:26 -0400
X-Greylist: delayed 429 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Mar 2020 12:38:24 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=3706; q=dns/txt; s=iport;
  t=1585154305; x=1586363905;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=XODqsNkzk78qQBBhDHsB4Un4cvki1BxKm7wKbk22n68=;
  b=JAbr8OsV6a3zLgK9aBr+d6zHSeHq+Xu40ocCmSIkjRbRKM+UexwD74ob
   IVWsJHmDEGki1wB7rpRxUzo1D2AGmiw5etbqVi5SflRxXBbnvi7V8q71Z
   Wq0UoIlCC2e37LI9Rc2l3mCo1InaXP55i9zRSMHx0Azvf3UExUIZP3hyu
   Q=;
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0ANAAAgh3te/xbLJq1mGgEBAQEBAQE?=
 =?us-ascii?q?BAQMBAQEBEQEBAQICAQEBAYFpAwEBAQELAYF8gW0gEiqEGYkCh2sIJYlsj2C?=
 =?us-ascii?q?BewoBAQEMAQEvBAEBhEQCgkw2Bw4CAwEBCwEBBQEBAQIBBQRthWKFYwEBAQE?=
 =?us-ascii?q?CASMVQRALFQMCAiYCAiE2BgEMBgIBAYMigkwDDiCtN3WBMoVLgmsNYoE+gQ4?=
 =?us-ascii?q?qAYxIgUE/gREnDIJhPoIbhUGCXgSNWIk3cZgRRIJGkkuENwYdjyeMNy2OZIt?=
 =?us-ascii?q?HkC0CBAsCFYFZAjCBWDMaCBsVgydQGA2OKReBBAEIjRo/AzCPJwEB?=
X-IronPort-AV: E=Sophos;i="5.72,304,1580774400"; 
   d="scan'208";a="24752855"
Received: from aer-iport-nat.cisco.com (HELO aer-core-2.cisco.com) ([173.38.203.22])
  by aer-iport-2.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 25 Mar 2020 16:31:14 +0000
Received: from [10.63.114.242] ([10.63.114.242])
        (authenticated bits=0)
        by aer-core-2.cisco.com (8.15.2/8.15.2) with ESMTPSA id 02PGVCim026801
        (version=TLSv1.2 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO);
        Wed, 25 Mar 2020 16:31:13 GMT
Subject: Re: [PATCH v2] PCI: sysfs: Change bus_rescan and dev_rescan to rescan
To:     Kelsey Skunberg <skunberg.kelsey@gmail.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Cc:     ddutile@redhat.com, bodong@mellanox.com,
        linux-kernel-mentees@lists.linuxfoundation.org,
        skhan@linuxfoundation.org, ruslan.bilovol@gmail.com,
        bhelgaas@google.com, Kelsey Skunberg <kelsey.skunberg@gmail.com>,
        stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20200325151708.32612-1-skunberg.kelsey@gmail.com>
From:   Ruslan Bilovol <rbilovol@cisco.com>
Message-ID: <bf3ffd93-5dac-0c38-9029-9e58bfb187a5@cisco.com>
Date:   Wed, 25 Mar 2020 18:31:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200325151708.32612-1-skunberg.kelsey@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-User: rbilovol
X-Outbound-SMTP-Client: 10.63.114.242, [10.63.114.242]
X-Outbound-Node: aer-core-2.cisco.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/25/20 5:17 PM, Kelsey Skunberg wrote:
> From: Kelsey Skunberg <kelsey.skunberg@gmail.com>
> 
> rename device attribute name arguments 'bus_rescan' and 'dev_rescan' to 'rescan'
> to avoid breaking userspace applications.
> 
> The attribute argument names were changed in the following commits:
> 8bdfa145f582 ("PCI: sysfs: Define device attributes with DEVICE_ATTR*()")
> 4e2b79436e4f ("PCI: sysfs: Change DEVICE_ATTR() to DEVICE_ATTR_WO()")
> 
> Revert the names used for attributes back to the names used before the above
> patches were applied. This also requires to change DEVICE_ATTR_WO() to
> DEVICE_ATTR() and __ATTR().
> 
> Note when using DEVICE_ATTR() the attribute is automatically named
> dev_attr_<name>.attr. To avoid duplicated names between attributes, use
> __ATTR() instead of DEVICE_ATTR() to a assign a custom attribute name for
> dev_rescan.
> 
> change bus_rescan_store() to dev_bus_rescan_store() to complete matching the
> names used before the mentioned patches were applied.
> 
> Fixes: 8bdfa145f582 ("PCI: sysfs: Define device attributes with DEVICE_ATTR*()")
> Fixes: 4e2b79436e4f ("PCI: sysfs: Change DEVICE_ATTR() to DEVICE_ATTR_WO()")

Thanks Kelsey for the quick fix.

Tested-by: Ruslan Bilovol <rbilovol@cisco.com>

> 
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Kelsey Skunberg <kelsey.skunberg@gmail.com>
> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
> 
> v2 updates:
> 	commit log updated to include 'Fixes: *' and Cc: stable to aid commit
> 	being backported properly.
> 
>   drivers/pci/pci-sysfs.c | 17 ++++++++++-------
>   1 file changed, 10 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
> index 13f766db0684..667e13d597ff 100644
> --- a/drivers/pci/pci-sysfs.c
> +++ b/drivers/pci/pci-sysfs.c
> @@ -464,7 +464,10 @@ static ssize_t dev_rescan_store(struct device *dev,
>   	}
>   	return count;
>   }
> -static DEVICE_ATTR_WO(dev_rescan);
> +static struct device_attribute dev_rescan_attr = __ATTR(rescan,
> +							0220, NULL,
> +							dev_rescan_store);
> +
>   
>   static ssize_t remove_store(struct device *dev, struct device_attribute *attr,
>   			    const char *buf, size_t count)
> @@ -481,9 +484,9 @@ static ssize_t remove_store(struct device *dev, struct device_attribute *attr,
>   static DEVICE_ATTR_IGNORE_LOCKDEP(remove, 0220, NULL,
>   				  remove_store);
>   
> -static ssize_t bus_rescan_store(struct device *dev,
> -				struct device_attribute *attr,
> -				const char *buf, size_t count)
> +static ssize_t dev_bus_rescan_store(struct device *dev,
> +				    struct device_attribute *attr,
> +				    const char *buf, size_t count)
>   {
>   	unsigned long val;
>   	struct pci_bus *bus = to_pci_bus(dev);
> @@ -501,7 +504,7 @@ static ssize_t bus_rescan_store(struct device *dev,
>   	}
>   	return count;
>   }
> -static DEVICE_ATTR_WO(bus_rescan);
> +static DEVICE_ATTR(rescan, 0220, NULL, dev_bus_rescan_store);
>   
>   #if defined(CONFIG_PM) && defined(CONFIG_ACPI)
>   static ssize_t d3cold_allowed_store(struct device *dev,
> @@ -641,7 +644,7 @@ static struct attribute *pcie_dev_attrs[] = {
>   };
>   
>   static struct attribute *pcibus_attrs[] = {
> -	&dev_attr_bus_rescan.attr,
> +	&dev_attr_rescan.attr,
>   	&dev_attr_cpuaffinity.attr,
>   	&dev_attr_cpulistaffinity.attr,
>   	NULL,
> @@ -1487,7 +1490,7 @@ static umode_t pci_dev_attrs_are_visible(struct kobject *kobj,
>   
>   static struct attribute *pci_dev_hp_attrs[] = {
>   	&dev_attr_remove.attr,
> -	&dev_attr_dev_rescan.attr,
> +	&dev_rescan_attr.attr,
>   	NULL,
>   };
>   
> 
