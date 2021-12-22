Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF6247D61D
	for <lists+stable@lfdr.de>; Wed, 22 Dec 2021 18:53:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234742AbhLVRx0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Dec 2021 12:53:26 -0500
Received: from mga12.intel.com ([192.55.52.136]:30294 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234640AbhLVRxZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Dec 2021 12:53:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640195605; x=1671731605;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=x0Yqt0Edekw759eVPj0zICnTeizEzXjxwbiRNPcJim0=;
  b=R6cGGlryG38REb/bu3CGfTrzQan6IRGxgBUr9gWNtqPPO2034OJ3AqRb
   yfFZMsE9ITIHxvh5fVE0PHHpszxrblg4s8TK+hF4cuigQyg2mXGCEAbXK
   uqDJ/uSqT39L3etct4V9CamasHmB/qHXI8DPAJu/uuxXFsi5TtVmcCbG7
   CdiBNqp5CtqCxgCJO88uB0LEktx/z3z/YVbzNGtRyfxwC35aka+PfLc2w
   +/ttESLMd+AxNjaTiBwc/GRkYZPTOr+kLxjKIa+uMbzkeThaIgQ+XL9/f
   7qzbNWNk3C6vdG4MArV5FZ7/VUNVGmAr43FQ25PiX2XW9yDAbUTSo2g7V
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10206"; a="220689824"
X-IronPort-AV: E=Sophos;i="5.88,227,1635231600"; 
   d="scan'208";a="220689824"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2021 09:46:01 -0800
X-IronPort-AV: E=Sophos;i="5.88,227,1635231600"; 
   d="scan'208";a="549682684"
Received: from mmoy1-mobl.amr.corp.intel.com ([10.212.163.250])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2021 09:45:58 -0800
Message-ID: <a41970ea5e650f49dfa6470ee47110c1be8719a7.camel@linux.intel.com>
Subject: Re: [PATCH] thermal/drivers/int340x: add functions for mbox read
 and write commands
From:   srinivas pandruvada <srinivas.pandruvada@linux.intel.com>
To:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Sumeet Pawnikar <sumeet.r.pawnikar@intel.com>
Cc:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>
Date:   Wed, 22 Dec 2021 09:45:58 -0800
In-Reply-To: <CAJZ5v0gyGsOjiFsw1FP4ZXP7yXNFwcjRtrbdR0Gov_xMFhYRew@mail.gmail.com>
References: <20211222165300.8222-1-sumeet.r.pawnikar@intel.com>
         <CAJZ5v0gyGsOjiFsw1FP4ZXP7yXNFwcjRtrbdR0Gov_xMFhYRew@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2021-12-22 at 17:56 +0100, Rafael J. Wysocki wrote:
> On Wed, Dec 22, 2021 at 5:53 PM Sumeet Pawnikar
> <sumeet.r.pawnikar@intel.com> wrote:
> > 
> > The existing mail mechanism only supports writing of workload
> > types.
> > But mailbox command for RFIM (cmd = 0x08) also requires write
> > operation
> > which was ignored. This results in failing to store RFI
> > restriction.
> > This requires enhancing mailbox writes for non workload commands
> > also.
> > So, remove the check for MBOX_CMD_WORKLOAD_TYPE_WRITE in mailbox
> > write,
> > with this other write commands also can be supoorted. But at the
> > same
> > time, we have to make sure that there is no impact on read
> > commands,
> > by not writing anything in mailbox data register.
> > To properly implement, add two separate functions for mbox read and
> > write
> > command for processor thermal workload command type. This helps to
> > differentiate the read and write workload command types while
> > sending mbox
> > command.
> > 
> > Fixes: 5d6fbc96bd36 ("thermal/drivers/int340x: processor_thermal:
> > Export additional attributes")
> > Signed-off-by: Sumeet Pawnikar <sumeet.r.pawnikar@intel.com>
> > Cc: stable@vger.kernel.org # 5.14+
> 
> This requires an ACK from Srinivas.

I found some more issues in this patch after my prior internal review.

1. Subject of patch should be what is this patch for rather than how.
Something like:
Fix RFIM mailbox write commands

2. There is one issue in the code below.

> 
> > ---
> > 

[...]

> > +static int send_mbox_read_cmd(struct pci_dev *pdev, u16 id, u32
> > data, u64 *resp)
There is no use of "data" argument for read  after spilt of read and
write commands, if you look at the code before.

> > +{
> > +       struct proc_thermal_device *proc_priv;
> > +       u32 reg_data;
> > +       int ret;
> > 
> > -               if (!cmd_resp)
> > -                       break;
> > +       proc_priv = pci_get_drvdata(pdev);
> > 
> > -               if (cmd_id == MBOX_CMD_WORKLOAD_TYPE_READ)
> > -                       *cmd_resp = readl((void __iomem *)
> > (proc_priv->mmio_base + MBOX_OFFSET_DATA));
> > -               else
> > -                       *cmd_resp = readq((void __iomem *)
> > (proc_priv->mmio_base + MBOX_OFFSET_DATA));
> > +       mutex_lock(&mbox_lock);
> > 
> > -               break;
> > -       } while (--retries);
> > +       ret = wait_for_mbox_ready(proc_priv);
> > +       if (ret)
> > +               goto unlock_mbox;
> > +
> > +       writel(data, (proc_priv->mmio_base + MBOX_OFFSET_DATA));
The above is not required for read. This is what we wanted to avoid for
reads. 

Thanks,
Srinivas

> > +       /* Write command register */
> > +       reg_data = BIT_ULL(MBOX_BUSY_BIT) | id;
> > +       writel(reg_data, (proc_priv->mmio_base +
> > MBOX_OFFSET_INTERFACE));
> > +
> > +       ret = wait_for_mbox_ready(proc_priv);
> > +       if (ret)
> > +               goto unlock_mbox;
> > +
> > +       if (id == MBOX_CMD_WORKLOAD_TYPE_READ)
> > +               *resp = readl(proc_priv->mmio_base +
> > MBOX_OFFSET_DATA);
> > +       else
> > +               *resp = readq(proc_priv->mmio_base +
> > MBOX_OFFSET_DATA);
> > 
> >  unlock_mbox:
> >         mutex_unlock(&mbox_lock);
> >         return ret;
> >  }
> > 
> > -int processor_thermal_send_mbox_cmd(struct pci_dev *pdev, u16
> > cmd_id, u32 cmd_data, u64 *cmd_resp)
> > +int processor_thermal_send_mbox_read_cmd(struct pci_dev *pdev, u16
> > id, u32 data, u64 *resp)
> >  {
> > -       return send_mbox_cmd(pdev, cmd_id, cmd_data, cmd_resp);
> > +       return send_mbox_read_cmd(pdev, id, data, resp);
> >  }
> > -EXPORT_SYMBOL_GPL(processor_thermal_send_mbox_cmd);
> > +EXPORT_SYMBOL_NS_GPL(processor_thermal_send_mbox_read_cmd,
> > INT340X_THERMAL);
> > +
> > +int processor_thermal_send_mbox_write_cmd(struct pci_dev *pdev,
> > u16 id, u32 data)
> > +{
> > +       return send_mbox_write_cmd(pdev, id, data);
> > +}
> > +EXPORT_SYMBOL_NS_GPL(processor_thermal_send_mbox_write_cmd,
> > INT340X_THERMAL);
> > 
> >  /* List of workload types */
> >  static const char * const workload_types[] = {
> > @@ -104,7 +126,6 @@ static const char * const workload_types[] = {
> >         NULL
> >  };
> > 


