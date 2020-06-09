Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34EF81F3DD8
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 16:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728832AbgFIOUM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 10:20:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:54312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726967AbgFIOUL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 10:20:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8F06206D5;
        Tue,  9 Jun 2020 14:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591712410;
        bh=HSeYCyX+M5Ng843ltjN3GLINElmDCvwhn5Vr6o3fIT8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wdXbpbWx22o8lCA7X1XcT7vQoXpeaf2/vOSfaqAWsXP7dyLmRqIhZiKROfpUdbo3V
         nfWkaugoydI1dDmg3/33jkTnmzd/EtXBY5gApnqyBdNGj4IPqwuc0EouWhHKmirepg
         3i+kJ22BA7LArD97agEzeq2oxxc8KhF+484ZUET8=
Date:   Tue, 9 Jun 2020 16:20:07 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     trix@redhat.com
Cc:     stable <stable@vger.kernel.org>, linux-fpga@vger.kernel.org,
        shuah@kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 1/1] selftests: fpga: dfl: A test for afu interrupt
 support
Message-ID: <20200609142007.GA831428@kroah.com>
References: <20200609130208.27390-1-trix@redhat.com>
 <20200609130208.27390-2-trix@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200609130208.27390-2-trix@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 09, 2020 at 06:02:08AM -0700, trix@redhat.com wrote:
> From: Tom Rix <trix@redhat.com>
> 
> Check that the ioctl DFL_FPGA_PORT_ERR_GET_IRQ_NUM returns
> an expected result.
> 
> Tested on vf device 0xbcc1
> 
> Sample run with
> $ sudo make -C tools/testing/selftests TARGETS=drivers/fpga run_tests
> ...
> ok 1 selftests: drivers/fpga: afu_intr
> 
> Signed-off-by: Tom Rix <trix@redhat.com>
> ---
>  tools/testing/selftests/Makefile              |  1 +
>  tools/testing/selftests/drivers/fpga/Makefile |  9 +++++
>  .../testing/selftests/drivers/fpga/afu_intr.c | 38 +++++++++++++++++++
>  tools/testing/selftests/drivers/fpga/config   |  1 +
>  4 files changed, 49 insertions(+)
>  create mode 100644 tools/testing/selftests/drivers/fpga/Makefile
>  create mode 100644 tools/testing/selftests/drivers/fpga/afu_intr.c
>  create mode 100644 tools/testing/selftests/drivers/fpga/config
> 
> diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
> index 1195bd85af38..4c6eda659125 100644
> --- a/tools/testing/selftests/Makefile
> +++ b/tools/testing/selftests/Makefile
> @@ -9,6 +9,7 @@ TARGETS += clone3
>  TARGETS += cpufreq
>  TARGETS += cpu-hotplug
>  TARGETS += drivers/dma-buf
> +TARGETS += drivers/fpga
>  TARGETS += efivarfs
>  TARGETS += exec
>  TARGETS += filesystems
> diff --git a/tools/testing/selftests/drivers/fpga/Makefile b/tools/testing/selftests/drivers/fpga/Makefile
> new file mode 100644
> index 000000000000..0a472e8c67c5
> --- /dev/null
> +++ b/tools/testing/selftests/drivers/fpga/Makefile
> @@ -0,0 +1,9 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +CFLAGS += -I../../../../../usr/include/
> +CFLAGS += -I../../../../../include/uapi/
> +
> +TEST_GEN_PROGS := afu_intr
> +
> +top_srcdir ?=../../../../..
> +
> +include ../../lib.mk
> diff --git a/tools/testing/selftests/drivers/fpga/afu_intr.c b/tools/testing/selftests/drivers/fpga/afu_intr.c
> new file mode 100644
> index 000000000000..aa1efba94605
> --- /dev/null
> +++ b/tools/testing/selftests/drivers/fpga/afu_intr.c
> @@ -0,0 +1,38 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <stdint.h>
> +#include <string.h>
> +#include <linux/fcntl.h>
> +#include <linux/fpga-dfl.h>
> +
> +#define TEST_PREFIX	"drivers/fpga/afu_intr"
> +
> +int main(int argc, char *argv[])
> +{
> +	int devfd, status;
> +	struct dfl_fpga_port_info port_info;
> +	uint32_t irq_num;
> +
> +	devfd = open("/dev/dfl-port.0", O_RDONLY);
> +	if (devfd < 0) {
> +		printf("%s: [skip,no-ufpgaintr]\n", TEST_PREFIX);
> +		exit(77);
> +	}
> +
> +	/*
> +	 * From fpga-dl.h :
> +	 * Currently hardware supports up to 1 irq.
> +	 * Return: 0 on success, -errno on failure.
> +	 */
> +	irq_num = -1;
> +	status = ioctl(devfd, DFL_FPGA_PORT_ERR_GET_IRQ_NUM, &irq_num);
> +	if (status != 0 || irq_num > 255) {
> +		printf("%s: [FAIL,err-get-irq-num]\n", TEST_PREFIX);
> +		close(devfd);
> +		exit(1);
> +	}
> +
> +	close(devfd);
> +	return 0;
> +}

Why not use the ksft_* functions and frameworks to properly print out
the test status and results so that tools can correctly parse it?

It's generally bad-form to make up your own format.

thanks,

gre gk-h
