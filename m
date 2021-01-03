Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ED482E8D21
	for <lists+stable@lfdr.de>; Sun,  3 Jan 2021 17:27:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbhACQ11 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Jan 2021 11:27:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:57496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726525AbhACQ10 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 3 Jan 2021 11:27:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CEF4E20C56;
        Sun,  3 Jan 2021 16:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609691205;
        bh=9RwAdYgsGbMkZI/sgXYkv2BpzryRIXETFKxEQ7M3MtQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=iBw5o8/5JnIbKy81jRxWQVc0rT84WXhMHgUtmt7KguQiT2JrvY+MqskctBBqKfsjE
         p/zRRRCn89kwkiH0+o4Y+Qv1xqll9ZXC1/kvFjw9MgwaQp38RQeLaOikEcdv4oxZpb
         FXlPSbg6CgJiYn/GDqiZOAtZUO7S6Xmt0QiBSfKqp8IbT8Smw+a0o9BGs31zSg7FF8
         zLG/DPAulW+TplITiQIKwAEDAxRKqAvGAuP+iMWXUD8eUzjdb3w22/cW63wlUftrtR
         DRKTODujIyDe0poBO1BJd4l+QGAL+liNy8W7Sk8kyNTW6yFngQIibbbbQGgU8Wnq7v
         4HjeYkwhQLJ7g==
Received: by mail-oi1-f173.google.com with SMTP id d203so29428563oia.0;
        Sun, 03 Jan 2021 08:26:45 -0800 (PST)
X-Gm-Message-State: AOAM5339WNpMEs6Bd0EIia1J6PpEuFC1o1/4JcHtMGoGil56wxy7CTm0
        hwguuyM4v/HxEBdSaPijhEJZBk7FwUG/S64UEKI=
X-Google-Smtp-Source: ABdhPJx+3jVekoiK6zhM+AKJJCW1XD/6zG3ISX882/yUKVfTfAGVcAFIf3L+UY089w1MriUP4jGZeGI2yBcJ8ZWRnww=
X-Received: by 2002:aca:44d:: with SMTP id 74mr16023653oie.4.1609691205172;
 Sun, 03 Jan 2021 08:26:45 -0800 (PST)
MIME-Version: 1.0
References: <20200908213715.3553098-1-arnd@arndb.de> <20200908213715.3553098-2-arnd@arndb.de>
 <20201231001553.GB16945@home.linuxace.com>
In-Reply-To: <20201231001553.GB16945@home.linuxace.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Sun, 3 Jan 2021 17:26:29 +0100
X-Gmail-Original-Message-ID: <CAK8P3a0_WORgd4Wvd3n+59oR=-rrESwg_MgpDJN4xPo_e6ir5Q@mail.gmail.com>
Message-ID: <CAK8P3a0_WORgd4Wvd3n+59oR=-rrESwg_MgpDJN4xPo_e6ir5Q@mail.gmail.com>
Subject: Re: [PATCH 2/3] scsi: megaraid_sas: check user-provided offsets
To:     Phil Oester <kernel@linuxace.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Anand Lodnoor <anand.lodnoor@broadcom.com>,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
        Hannes Reinecke <hare@suse.de>, megaraidlinux.pdl@broadcom.com,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 31, 2020 at 1:15 AM Phil Oester <kernel@linuxace.com> wrote:
>
> On Tue, Sep 08, 2020 at 11:36:22PM +0200, Arnd Bergmann wrote:
> > It sounds unwise to let user space pass an unchecked 32-bit
> > offset into a kernel structure in an ioctl. This is an unsigned
> > variable, so checking the upper bound for the size of the structure
> > it points into is sufficient to avoid data corruption, but as
> > the pointer might also be unaligned, it has to be written carefully
> > as well.
> >
> > While I stumbled over this problem by reading the code, I did not
> > continue checking the function for further problems like it.
>
> Sorry for replying to an ancient thread, but this patch just recently
> made it into 5.10.3 and has caused unintended consequences.  On Dell
> servers with PERC RAID controllers, booting 5.10.3+ with this patch
> causes a PCI parity error.  Specifically:
>
> Event Message: A PCI parity error was detected on a component at bus 0 device 5 function 0.
> Severity: Critical
> Message ID: PCI1308
>
> I reverted this single patch and the errors went away.
>
> Thoughts?

Thank you for the report and bisecting the issue, and sorry this broke
your system!

Fortunately, the patch is fairly small, so there are only a limited number
of things that could go wrong. I haven't tried to analyze that message,
but I have two ideas:

a) The added ioc->sense_off check gets triggered and the code relies
  on the data being written outside of the structure

b) the address actually needs to always be written as a 64-bit value
    regardless of the instance->consistent_mask_64bit flag, as the
   driver did before. This looked like it was done in error.

Can you try the patch below instead of the revert and see if that
resolves the regression, and if it triggers the warning message I
add?

       Arnd

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
b/drivers/scsi/megaraid/megaraid_sas_base.c
index 6e4bf05c6d77..248063a4148b 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -8194,8 +8194,7 @@ megasas_mgmt_fw_ioctl(struct megasas_instance *instance,
                /* make sure the pointer is part of the frame */
                if (ioc->sense_off >
                    (sizeof(union megasas_frame) - sizeof(__le64))) {
-                       error = -EINVAL;
-                       goto out;
+                       pr_warn("possible out of bounds access offset
%d\n", ioc->sense_off);
                }

                sense = dma_alloc_coherent(&instance->pdev->dev, ioc->sense_len,
@@ -8209,7 +8208,7 @@ megasas_mgmt_fw_ioctl(struct megasas_instance *instance,
                if (instance->consistent_mask_64bit)
                        put_unaligned_le64(sense_handle, sense_ptr);
                else
-                       put_unaligned_le32(sense_handle, sense_ptr);
+                       put_unaligned_le64(sense_handle, sense_ptr);
        }

        /*
