Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C80AE227027
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 23:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726390AbgGTVGb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 17:06:31 -0400
Received: from mga12.intel.com ([192.55.52.136]:9936 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726046AbgGTVGa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 17:06:30 -0400
IronPort-SDR: 0/L89gc1NJSZOCn0wu1Nz8UCsV+cJ0XiBdV+Na3kXUnYsOZFOZXnkou2R7PdDMjK5DDVg8UA60
 /F8U6142337g==
X-IronPort-AV: E=McAfee;i="6000,8403,9688"; a="129576830"
X-IronPort-AV: E=Sophos;i="5.75,375,1589266800"; 
   d="gz'50?scan'50,208,50";a="129576830"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2020 13:43:28 -0700
IronPort-SDR: 8p146Y1E56oOq8AYmZrAmRwBLq1BnIRXTs3XoLXxZz2D3bWEUDQShKudj90jnt9lqtenKQAcRA
 UP7w/+81Mq8A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,375,1589266800"; 
   d="gz'50?scan'50,208,50";a="283637039"
Received: from lkp-server02.sh.intel.com (HELO f58f3bfa75fb) ([10.239.97.151])
  by orsmga003.jf.intel.com with ESMTP; 20 Jul 2020 13:43:24 -0700
Received: from kbuild by f58f3bfa75fb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1jxcdA-000083-4X; Mon, 20 Jul 2020 20:43:24 +0000
Date:   Tue, 21 Jul 2020 04:43:12 +0800
From:   kernel test robot <lkp@intel.com>
To:     Ashok Raj <ashok.raj@intel.com>, linux-pci@vger.kernel.org,
        Bjorn Helgaas <helgaas@kernel.org>,
        Joerg Roedel <joro@8bytes.org>, Lu Baolu <baolu.lu@intel.com>
Cc:     kbuild-all@lists.01.org, Ashok Raj <ashok.raj@intel.com>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org
Subject: Re: [PATCH] PCI/ATS: PASID and PRI are only enumerated in PF devices.
Message-ID: <202007210424.pROONnCE%lkp@intel.com>
References: <1595263380-209956-1-git-send-email-ashok.raj@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ew6BAiZeqk4r7MaW"
Content-Disposition: inline
In-Reply-To: <1595263380-209956-1-git-send-email-ashok.raj@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Ashok,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on pci/next]
[also build test ERROR on iommu/next linux/master linus/master v5.8-rc6 next-20200720]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Ashok-Raj/PCI-ATS-PASID-and-PRI-are-only-enumerated-in-PF-devices/20200721-004510
base:   https://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git next
config: x86_64-kexec (attached as .config)
compiler: gcc-9 (Debian 9.3.0-14) 9.3.0
reproduce (this is a W=1 build):
        # save the attached .config to linux build tree
        make W=1 ARCH=x86_64 

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   drivers/iommu/intel/iommu.c: In function 'dmar_insert_one_dev_info':
>> drivers/iommu/intel/iommu.c:2557:8: error: implicit declaration of function 'pci_pri_supported'; did you mean 'pci_ats_supported'? [-Werror=implicit-function-declaration]
    2557 |        pci_pri_supported(pdev))
         |        ^~~~~~~~~~~~~~~~~
         |        pci_ats_supported
   cc1: some warnings being treated as errors

vim +2557 drivers/iommu/intel/iommu.c

  2504	
  2505	static struct dmar_domain *dmar_insert_one_dev_info(struct intel_iommu *iommu,
  2506							    int bus, int devfn,
  2507							    struct device *dev,
  2508							    struct dmar_domain *domain)
  2509	{
  2510		struct dmar_domain *found = NULL;
  2511		struct device_domain_info *info;
  2512		unsigned long flags;
  2513		int ret;
  2514	
  2515		info = alloc_devinfo_mem();
  2516		if (!info)
  2517			return NULL;
  2518	
  2519		if (!dev_is_real_dma_subdevice(dev)) {
  2520			info->bus = bus;
  2521			info->devfn = devfn;
  2522			info->segment = iommu->segment;
  2523		} else {
  2524			struct pci_dev *pdev = to_pci_dev(dev);
  2525	
  2526			info->bus = pdev->bus->number;
  2527			info->devfn = pdev->devfn;
  2528			info->segment = pci_domain_nr(pdev->bus);
  2529		}
  2530	
  2531		info->ats_supported = info->pasid_supported = info->pri_supported = 0;
  2532		info->ats_enabled = info->pasid_enabled = info->pri_enabled = 0;
  2533		info->ats_qdep = 0;
  2534		info->dev = dev;
  2535		info->domain = domain;
  2536		info->iommu = iommu;
  2537		info->pasid_table = NULL;
  2538		info->auxd_enabled = 0;
  2539		INIT_LIST_HEAD(&info->auxiliary_domains);
  2540	
  2541		if (dev && dev_is_pci(dev)) {
  2542			struct pci_dev *pdev = to_pci_dev(info->dev);
  2543	
  2544			if (ecap_dev_iotlb_support(iommu->ecap) &&
  2545			    pci_ats_supported(pdev) &&
  2546			    dmar_find_matched_atsr_unit(pdev))
  2547				info->ats_supported = 1;
  2548	
  2549			if (sm_supported(iommu)) {
  2550				if (pasid_supported(iommu)) {
  2551					int features = pci_pasid_features(pdev);
  2552					if (features >= 0)
  2553						info->pasid_supported = features | 1;
  2554				}
  2555	
  2556				if (info->ats_supported && ecap_prs(iommu->ecap) &&
> 2557				    pci_pri_supported(pdev))
  2558					info->pri_supported = 1;
  2559			}
  2560		}
  2561	
  2562		spin_lock_irqsave(&device_domain_lock, flags);
  2563		if (dev)
  2564			found = find_domain(dev);
  2565	
  2566		if (!found) {
  2567			struct device_domain_info *info2;
  2568			info2 = dmar_search_domain_by_dev_info(info->segment, info->bus,
  2569							       info->devfn);
  2570			if (info2) {
  2571				found      = info2->domain;
  2572				info2->dev = dev;
  2573			}
  2574		}
  2575	
  2576		if (found) {
  2577			spin_unlock_irqrestore(&device_domain_lock, flags);
  2578			free_devinfo_mem(info);
  2579			/* Caller must free the original domain */
  2580			return found;
  2581		}
  2582	
  2583		spin_lock(&iommu->lock);
  2584		ret = domain_attach_iommu(domain, iommu);
  2585		spin_unlock(&iommu->lock);
  2586	
  2587		if (ret) {
  2588			spin_unlock_irqrestore(&device_domain_lock, flags);
  2589			free_devinfo_mem(info);
  2590			return NULL;
  2591		}
  2592	
  2593		list_add(&info->link, &domain->devices);
  2594		list_add(&info->global, &device_domain_list);
  2595		if (dev)
  2596			dev->archdata.iommu = info;
  2597		spin_unlock_irqrestore(&device_domain_lock, flags);
  2598	
  2599		/* PASID table is mandatory for a PCI device in scalable mode. */
  2600		if (dev && dev_is_pci(dev) && sm_supported(iommu)) {
  2601			ret = intel_pasid_alloc_table(dev);
  2602			if (ret) {
  2603				dev_err(dev, "PASID table allocation failed\n");
  2604				dmar_remove_one_dev_info(dev);
  2605				return NULL;
  2606			}
  2607	
  2608			/* Setup the PASID entry for requests without PASID: */
  2609			spin_lock(&iommu->lock);
  2610			if (hw_pass_through && domain_type_is_si(domain))
  2611				ret = intel_pasid_setup_pass_through(iommu, domain,
  2612						dev, PASID_RID2PASID);
  2613			else if (domain_use_first_level(domain))
  2614				ret = domain_setup_first_level(iommu, domain, dev,
  2615						PASID_RID2PASID);
  2616			else
  2617				ret = intel_pasid_setup_second_level(iommu, domain,
  2618						dev, PASID_RID2PASID);
  2619			spin_unlock(&iommu->lock);
  2620			if (ret) {
  2621				dev_err(dev, "Setup RID2PASID failed\n");
  2622				dmar_remove_one_dev_info(dev);
  2623				return NULL;
  2624			}
  2625		}
  2626	
  2627		if (dev && domain_context_mapping(domain, dev)) {
  2628			dev_err(dev, "Domain context map failed\n");
  2629			dmar_remove_one_dev_info(dev);
  2630			return NULL;
  2631		}
  2632	
  2633		return domain;
  2634	}
  2635	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--ew6BAiZeqk4r7MaW
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--ew6BAiZeqk4r7MaW--
