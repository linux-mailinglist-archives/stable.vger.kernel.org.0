Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3EA647E57A
	for <lists+stable@lfdr.de>; Thu, 23 Dec 2021 16:31:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239959AbhLWPbA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Dec 2021 10:31:00 -0500
Received: from mga11.intel.com ([192.55.52.93]:34646 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232660AbhLWPa7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Dec 2021 10:30:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640273459; x=1671809459;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KaH6s917MelJx/SHsiyMAKL9Sb4r3/efw62MyR6SFr0=;
  b=TPxJmV5lfGY3h5NMEeOG9FYfz+rrJsFZEkmrWAsFEcfJ0gkHpRC9AbWV
   9bI45t8HEiD8mhi++k4Weus3PGw11o4Tw2IxzEe5gMmqTl3neZmghrxIM
   aWaii+H2b6XhBVvlpKBL/0Fz/B8jYb4Uis+4cME4hSCcs6GgEl1knCgnw
   o3FtRSuRsxWkLMsilR3QjcslRCtKm+ZsPsJSahs8ZlIXFIXWHA2kPK4Fd
   M+DX0jXHVl0sQJRQfOSf8/QQqb/VW4zRcs1qei+nUtwihd8m7XcYeZfYW
   LZY14FNk47EQwWVSXkBFuwwBpoHfLtt7bOJa8dpEZcbvVjm0dlj3WTiGD
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10206"; a="238376921"
X-IronPort-AV: E=Sophos;i="5.88,229,1635231600"; 
   d="scan'208";a="238376921"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Dec 2021 07:30:59 -0800
X-IronPort-AV: E=Sophos;i="5.88,229,1635231600"; 
   d="scan'208";a="522126728"
Received: from kbang-mobl1.amr.corp.intel.com ([10.252.136.53])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Dec 2021 07:30:58 -0800
Message-ID: <2b55b71aaa89e9010d58f5b3c7f5823782ab760c.camel@linux.intel.com>
Subject: Re: [PATCH v2] thermal/drivers/int340x: Fix RFIM mailbox write
 commands
From:   srinivas pandruvada <srinivas.pandruvada@linux.intel.com>
To:     Sumeet Pawnikar <sumeet.r.pawnikar@intel.com>, rafael@kernel.org,
        daniel.lezcano@linaro.org, linux-pm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date:   Thu, 23 Dec 2021 07:30:58 -0800
In-Reply-To: <20211223094236.15179-1-sumeet.r.pawnikar@intel.com>
References: <20211223094236.15179-1-sumeet.r.pawnikar@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2021-12-23 at 15:12 +0530, Sumeet Pawnikar wrote:
> The existing mail mechanism only supports writing of workload types.
> But mailbox command for RFIM (cmd = 0x08) also requires write operation
> which was ignored. This results in failing to store RFI restriction.
> This requires enhancing mailbox writes for non workload commands also.
> So, remove the check for MBOX_CMD_WORKLOAD_TYPE_WRITE in mailbox write,
> with this other write commands also can be supoorted. But at the same
> time, we have to make sure that there is no impact on read commands,
> by not writing anything in mailbox data register.
> To properly implement, add two separate functions for mbox read and
> write
> command for processor thermal workload command type. This helps to
> differentiate the read and write workload command types while sending
> mbox
> command.
> 
> Fixes: 5d6fbc96bd36 ("thermal/drivers/int340x: processor_thermal:
> Export additional attributes")
> Signed-off-by: Sumeet Pawnikar <sumeet.r.pawnikar@intel.com>
> Cc: stable@vger.kernel.org # 5.14+
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

> ---
> Changes in v2 from v1:
>  - Addressed below review comments received from Srinivas.
>    - updated subject line.
>    - removed data argument for send_mbox_read_cmd function as it's not
> used.
>    - removed writel call inside send_mbox_read_cmd function which is
> not required.
> ---
>  .../processor_thermal_device.h                |   3 +-
>  .../int340x_thermal/processor_thermal_mbox.c  | 100 +++++++++++-------
>  .../int340x_thermal/processor_thermal_rfim.c  |  23 ++--
>  3 files changed, 73 insertions(+), 53 deletions(-)
> 
> diff --git
> a/drivers/thermal/intel/int340x_thermal/processor_thermal_device.h
> b/drivers/thermal/intel/int340x_thermal/processor_thermal_device.h
> index be27f633e40a..9b2a64ef55d0 100644
> --- a/drivers/thermal/intel/int340x_thermal/processor_thermal_device.h
> +++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_device.h
> @@ -80,7 +80,8 @@ void proc_thermal_rfim_remove(struct pci_dev *pdev);
>  int proc_thermal_mbox_add(struct pci_dev *pdev, struct
> proc_thermal_device *proc_priv);
>  void proc_thermal_mbox_remove(struct pci_dev *pdev);
>  
> -int processor_thermal_send_mbox_cmd(struct pci_dev *pdev, u16 cmd_id,
> u32 cmd_data, u64 *cmd_resp);
> +int processor_thermal_send_mbox_read_cmd(struct pci_dev *pdev, u16 id,
> u64 *resp);
> +int processor_thermal_send_mbox_write_cmd(struct pci_dev *pdev, u16
> id, u32 data);
>  int proc_thermal_add(struct device *dev, struct proc_thermal_device
> *priv);
>  void proc_thermal_remove(struct proc_thermal_device *proc_priv);
>  int proc_thermal_suspend(struct device *dev);
> diff --git
> a/drivers/thermal/intel/int340x_thermal/processor_thermal_mbox.c
> b/drivers/thermal/intel/int340x_thermal/processor_thermal_mbox.c
> index 01008ae00e7f..0b89a4340ff4 100644
> --- a/drivers/thermal/intel/int340x_thermal/processor_thermal_mbox.c
> +++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_mbox.c
> @@ -24,19 +24,15 @@
>  
>  static DEFINE_MUTEX(mbox_lock);
>  
> -static int send_mbox_cmd(struct pci_dev *pdev, u16 cmd_id, u32
> cmd_data, u64 *cmd_resp)
> +static int wait_for_mbox_ready(struct proc_thermal_device *proc_priv)
>  {
> -       struct proc_thermal_device *proc_priv;
>         u32 retries, data;
>         int ret;
>  
> -       mutex_lock(&mbox_lock);
> -       proc_priv = pci_get_drvdata(pdev);
> -
>         /* Poll for rb bit == 0 */
>         retries = MBOX_RETRY_COUNT;
>         do {
> -               data = readl((void __iomem *) (proc_priv->mmio_base +
> MBOX_OFFSET_INTERFACE));
> +               data = readl(proc_priv->mmio_base +
> MBOX_OFFSET_INTERFACE);
>                 if (data & BIT_ULL(MBOX_BUSY_BIT)) {
>                         ret = -EBUSY;
>                         continue;
> @@ -45,53 +41,78 @@ static int send_mbox_cmd(struct pci_dev *pdev, u16
> cmd_id, u32 cmd_data, u64 *cm
>                 break;
>         } while (--retries);
>  
> +       return ret;
> +}
> +
> +static int send_mbox_write_cmd(struct pci_dev *pdev, u16 id, u32 data)
> +{
> +       struct proc_thermal_device *proc_priv;
> +       u32 reg_data;
> +       int ret;
> +
> +       proc_priv = pci_get_drvdata(pdev);
> +
> +       mutex_lock(&mbox_lock);
> +
> +       ret = wait_for_mbox_ready(proc_priv);
>         if (ret)
>                 goto unlock_mbox;
>  
> -       if (cmd_id == MBOX_CMD_WORKLOAD_TYPE_WRITE)
> -               writel(cmd_data, (void __iomem *) ((proc_priv-
> >mmio_base + MBOX_OFFSET_DATA)));
> -
> +       writel(data, (proc_priv->mmio_base + MBOX_OFFSET_DATA));
>         /* Write command register */
> -       data = BIT_ULL(MBOX_BUSY_BIT) | cmd_id;
> -       writel(data, (void __iomem *) ((proc_priv->mmio_base +
> MBOX_OFFSET_INTERFACE)));
> +       reg_data = BIT_ULL(MBOX_BUSY_BIT) | id;
> +       writel(reg_data, (proc_priv->mmio_base +
> MBOX_OFFSET_INTERFACE));
>  
> -       /* Poll for rb bit == 0 */
> -       retries = MBOX_RETRY_COUNT;
> -       do {
> -               data = readl((void __iomem *) (proc_priv->mmio_base +
> MBOX_OFFSET_INTERFACE));
> -               if (data & BIT_ULL(MBOX_BUSY_BIT)) {
> -                       ret = -EBUSY;
> -                       continue;
> -               }
> +       ret = wait_for_mbox_ready(proc_priv);
>  
> -               if (data) {
> -                       ret = -ENXIO;
> -                       goto unlock_mbox;
> -               }
> +unlock_mbox:
> +       mutex_unlock(&mbox_lock);
> +       return ret;
> +}
>  
> -               ret = 0;
> +static int send_mbox_read_cmd(struct pci_dev *pdev, u16 id, u64 *resp)
> +{
> +       struct proc_thermal_device *proc_priv;
> +       u32 reg_data;
> +       int ret;
>  
> -               if (!cmd_resp)
> -                       break;
> +       proc_priv = pci_get_drvdata(pdev);
>  
> -               if (cmd_id == MBOX_CMD_WORKLOAD_TYPE_READ)
> -                       *cmd_resp = readl((void __iomem *) (proc_priv-
> >mmio_base + MBOX_OFFSET_DATA));
> -               else
> -                       *cmd_resp = readq((void __iomem *) (proc_priv-
> >mmio_base + MBOX_OFFSET_DATA));
> +       mutex_lock(&mbox_lock);
>  
> -               break;
> -       } while (--retries);
> +       ret = wait_for_mbox_ready(proc_priv);
> +       if (ret)
> +               goto unlock_mbox;
> +
> +       /* Write command register */
> +       reg_data = BIT_ULL(MBOX_BUSY_BIT) | id;
> +       writel(reg_data, (proc_priv->mmio_base +
> MBOX_OFFSET_INTERFACE));
> +
> +       ret = wait_for_mbox_ready(proc_priv);
> +       if (ret)
> +               goto unlock_mbox;
> +
> +       if (id == MBOX_CMD_WORKLOAD_TYPE_READ)
> +               *resp = readl(proc_priv->mmio_base + MBOX_OFFSET_DATA);
> +       else
> +               *resp = readq(proc_priv->mmio_base + MBOX_OFFSET_DATA);
>  
>  unlock_mbox:
>         mutex_unlock(&mbox_lock);
>         return ret;
>  }
>  
> -int processor_thermal_send_mbox_cmd(struct pci_dev *pdev, u16 cmd_id,
> u32 cmd_data, u64 *cmd_resp)
> +int processor_thermal_send_mbox_read_cmd(struct pci_dev *pdev, u16 id,
> u64 *resp)
>  {
> -       return send_mbox_cmd(pdev, cmd_id, cmd_data, cmd_resp);
> +       return send_mbox_read_cmd(pdev, id, resp);
>  }
> -EXPORT_SYMBOL_GPL(processor_thermal_send_mbox_cmd);
> +EXPORT_SYMBOL_NS_GPL(processor_thermal_send_mbox_read_cmd,
> INT340X_THERMAL);
> +
> +int processor_thermal_send_mbox_write_cmd(struct pci_dev *pdev, u16
> id, u32 data)
> +{
> +       return send_mbox_write_cmd(pdev, id, data);
> +}
> +EXPORT_SYMBOL_NS_GPL(processor_thermal_send_mbox_write_cmd,
> INT340X_THERMAL);
>  
>  /* List of workload types */
>  static const char * const workload_types[] = {
> @@ -104,7 +125,6 @@ static const char * const workload_types[] = {
>         NULL
>  };
>  
> -
>  static ssize_t workload_available_types_show(struct device *dev,
>                                                struct device_attribute
> *attr,
>                                                char *buf)
> @@ -146,7 +166,7 @@ static ssize_t workload_type_store(struct device
> *dev,
>  
>         data |= ret;
>  
> -       ret = send_mbox_cmd(pdev, MBOX_CMD_WORKLOAD_TYPE_WRITE, data,
> NULL);
> +       ret = send_mbox_write_cmd(pdev, MBOX_CMD_WORKLOAD_TYPE_WRITE,
> data);
>         if (ret)
>                 return false;
>  
> @@ -161,7 +181,7 @@ static ssize_t workload_type_show(struct device
> *dev,
>         u64 cmd_resp;
>         int ret;
>  
> -       ret = send_mbox_cmd(pdev, MBOX_CMD_WORKLOAD_TYPE_READ, 0,
> &cmd_resp);
> +       ret = send_mbox_read_cmd(pdev, MBOX_CMD_WORKLOAD_TYPE_READ,
> &cmd_resp);
>         if (ret)
>                 return false;
>  
> @@ -186,8 +206,6 @@ static const struct attribute_group
> workload_req_attribute_group = {
>         .name = "workload_request"
>  };
>  
> -
> -
>  static bool workload_req_created;
>  
>  int proc_thermal_mbox_add(struct pci_dev *pdev, struct
> proc_thermal_device *proc_priv)
> @@ -196,7 +214,7 @@ int proc_thermal_mbox_add(struct pci_dev *pdev,
> struct proc_thermal_device *proc
>         int ret;
>  
>         /* Check if there is a mailbox support, if fails return success
> */
> -       ret = send_mbox_cmd(pdev, MBOX_CMD_WORKLOAD_TYPE_READ, 0,
> &cmd_resp);
> +       ret = send_mbox_read_cmd(pdev, MBOX_CMD_WORKLOAD_TYPE_READ,
> &cmd_resp);
>         if (ret)
>                 return 0;
>  
> diff --git
> a/drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c
> b/drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c
> index e693ec8234fb..8c42e7662033 100644
> --- a/drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c
> +++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c
> @@ -9,6 +9,8 @@
>  #include <linux/pci.h>
>  #include "processor_thermal_device.h"
>  
> +MODULE_IMPORT_NS(INT340X_THERMAL);
> +
>  struct mmio_reg {
>         int read_only;
>         u32 offset;
> @@ -194,8 +196,7 @@ static ssize_t rfi_restriction_store(struct device
> *dev,
>                                      struct device_attribute *attr,
>                                      const char *buf, size_t count)
>  {
> -       u16 cmd_id = 0x0008;
> -       u64 cmd_resp;
> +       u16 id = 0x0008;
>         u32 input;
>         int ret;
>  
> @@ -203,7 +204,7 @@ static ssize_t rfi_restriction_store(struct device
> *dev,
>         if (ret)
>                 return ret;
>  
> -       ret = processor_thermal_send_mbox_cmd(to_pci_dev(dev), cmd_id,
> input, &cmd_resp);
> +       ret = processor_thermal_send_mbox_write_cmd(to_pci_dev(dev),
> id, input);
>         if (ret)
>                 return ret;
>  
> @@ -214,30 +215,30 @@ static ssize_t rfi_restriction_show(struct device
> *dev,
>                                     struct device_attribute *attr,
>                                     char *buf)
>  {
> -       u16 cmd_id = 0x0007;
> -       u64 cmd_resp;
> +       u16 id = 0x0007;
> +       u64 resp;
>         int ret;
>  
> -       ret = processor_thermal_send_mbox_cmd(to_pci_dev(dev), cmd_id,
> 0, &cmd_resp);
> +       ret = processor_thermal_send_mbox_read_cmd(to_pci_dev(dev), id,
> &resp);
>         if (ret)
>                 return ret;
>  
> -       return sprintf(buf, "%llu\n", cmd_resp);
> +       return sprintf(buf, "%llu\n", resp);
>  }
>  
>  static ssize_t ddr_data_rate_show(struct device *dev,
>                                   struct device_attribute *attr,
>                                   char *buf)
>  {
> -       u16 cmd_id = 0x0107;
> -       u64 cmd_resp;
> +       u16 id = 0x0107;
> +       u64 resp;
>         int ret;
>  
> -       ret = processor_thermal_send_mbox_cmd(to_pci_dev(dev), cmd_id,
> 0, &cmd_resp);
> +       ret = processor_thermal_send_mbox_read_cmd(to_pci_dev(dev), id,
> &resp);
>         if (ret)
>                 return ret;
>  
> -       return sprintf(buf, "%llu\n", cmd_resp);
> +       return sprintf(buf, "%llu\n", resp);
>  }
>  
>  static DEVICE_ATTR_RW(rfi_restriction);


