Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D6711D554F
	for <lists+stable@lfdr.de>; Fri, 15 May 2020 17:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbgEOP6y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 May 2020 11:58:54 -0400
Received: from mga11.intel.com ([192.55.52.93]:23856 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726407AbgEOP6x (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 May 2020 11:58:53 -0400
IronPort-SDR: 2mHQnDI+cDVuxPl4+6x4XzYcU9BCzxzHCrj7+4wEp8s+/sre3qQeA2EMi46obvskbTsdfHECEA
 YPKufeby6AzA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2020 08:58:53 -0700
IronPort-SDR: HirYw8rAPztdjIA+/NI+F9pTHI7jr2RVdgGVqpP6A1KNTRdCnoAGKJuyB90njmSwKQdRaaUe4r
 3Fk2+H3/lEUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,395,1583222400"; 
   d="scan'208";a="263229930"
Received: from rjwysock-mobl1.ger.corp.intel.com (HELO [10.249.131.101]) ([10.249.131.101])
  by orsmga003.jf.intel.com with ESMTP; 15 May 2020 08:58:48 -0700
Subject: Re: [PATCH v2 20/20] cpufreq: Return zero on success in boost sw
 setting
To:     Sergey.Semin@baikalelectronics.ru,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Matthias Kaehlcke <mka@chromium.org>
Cc:     Serge Semin <fancer.lancer@gmail.com>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Paul Burton <paulburton@kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <robh+dt@kernel.org>, linux-mips@vger.kernel.org,
        devicetree@vger.kernel.org, stable@vger.kernel.org,
        Frederic Weisbecker <frederic@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Yue Hu <huyue2@yulong.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200306124807.3596F80307C2@mail.baikalelectronics.ru>
 <20200506174238.15385-1-Sergey.Semin@baikalelectronics.ru>
 <20200506174238.15385-21-Sergey.Semin@baikalelectronics.ru>
From:   "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Organization: Intel Technology Poland Sp. z o. o., KRS 101882, ul. Slowackiego
 173, 80-298 Gdansk
Message-ID: <c5109483-4c14-1a0c-efa9-51edf01c12de@intel.com>
Date:   Fri, 15 May 2020 17:58:47 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200506174238.15385-21-Sergey.Semin@baikalelectronics.ru>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/6/2020 7:42 PM, Sergey.Semin@baikalelectronics.ru wrote:
> From: Serge Semin <Sergey.Semin@baikalelectronics.ru>
>
> Recent commit e61a41256edf ("cpufreq: dev_pm_qos_update_request() can
> return 1 on success") fixed a problem when active policies traverse
> was falsely stopped due to invalidly treating the non-zero return value
> from freq_qos_update_request() method as an error. Yes, that function
> can return positive values if the requested update actually took place.
> The current problem is that the returned value is then passed to the
> return cell of the cpufreq_boost_set_sw() (set_boost callback) method.
> This value is then also analyzed for being non-zero, which is also
> treated as having an error. As a result during the boost activation
> we'll get an error returned while having the QOS frequency update
> successfully performed. Fix this by returning a negative value from the
> cpufreq_boost_set_sw() if actual error was encountered and zero
> otherwise treating any positive values as the successful operations
> completion.
>
> Fixes: 18c49926c4bf ("cpufreq: Add QoS requests for userspace constraints")
> Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
> Cc: Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>
> Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> Cc: Paul Burton <paulburton@kernel.org>
> Cc: Ralf Baechle <ralf@linux-mips.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: linux-mips@vger.kernel.org
> Cc: devicetree@vger.kernel.org
> Cc: stable@vger.kernel.org
> ---
>   drivers/cpufreq/cpufreq.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 045f9fe157ce..5870cdca88cf 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -2554,7 +2554,7 @@ static int cpufreq_boost_set_sw(int state)
>   			break;
>   	}
>   
> -	return ret;
> +	return ret < 0 ? ret : 0;
>   }
>   
>   int cpufreq_boost_trigger_state(int state)

IMO it is better to update the caller of this function to handle the 
positive value possibly returned by it correctly.

Thanks!


