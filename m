Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA31F1D746B
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 11:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbgERJx3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 05:53:29 -0400
Received: from mga07.intel.com ([134.134.136.100]:29861 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726127AbgERJx2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 05:53:28 -0400
IronPort-SDR: fOjCcUXM30INFO0ZwLVMQwn3+o3YQtSBOVuGF3mmX3lnNvlIX0vDS3dHB4tjpbW6kaABYLmnlQ
 2ezaBRLQDbiA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2020 02:53:28 -0700
IronPort-SDR: IPxhcZLdyUPpSJDtRywqmENMCEXb8iNw2LOGME7vov3Pi2g/kBh+2kmc4fcyM75/P26UqVcqln
 tzZ03x2Y4dtA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,406,1583222400"; 
   d="scan'208";a="281919241"
Received: from rjwysock-mobl1.ger.corp.intel.com (HELO [10.249.149.12]) ([10.249.149.12])
  by orsmga002.jf.intel.com with ESMTP; 18 May 2020 02:53:22 -0700
Subject: Re: [PATCH v2 20/20] cpufreq: Return zero on success in boost sw
 setting
To:     Viresh Kumar <viresh.kumar@linaro.org>,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>
Cc:     Serge Semin <fancer.lancer@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Matthias Kaehlcke <mka@chromium.org>,
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
 <c5109483-4c14-1a0c-efa9-51edf01c12de@intel.com>
 <20200516125203.et5gkv6ullkerjyd@mobilestation>
 <20200518074142.c6kbofpdlxro2pjz@vireshk-i7>
From:   "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Organization: Intel Technology Poland Sp. z o. o., KRS 101882, ul. Slowackiego
 173, 80-298 Gdansk
Message-ID: <a8dfa493-f858-e35d-7e57-78478be555c4@intel.com>
Date:   Mon, 18 May 2020 11:53:22 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200518074142.c6kbofpdlxro2pjz@vireshk-i7>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/18/2020 9:41 AM, Viresh Kumar wrote:
> On 16-05-20, 15:52, Serge Semin wrote:
>> On Fri, May 15, 2020 at 05:58:47PM +0200, Rafael J. Wysocki wrote:
>>>> @@ -2554,7 +2554,7 @@ static int cpufreq_boost_set_sw(int state)
>>>>    			break;
>>>>    	}
>>>> -	return ret;
>>>> +	return ret < 0 ? ret : 0;
>>>>    }
>>>>    int cpufreq_boost_trigger_state(int state)
>>> IMO it is better to update the caller of this function to handle the
>>> positive value possibly returned by it correctly.
>> Could you elaborate why? Viresh seems to be ok with this solution.
> And it is absolutely fine for Rafael to not agree with it :)
>
>> As I see it the caller doesn't expect the positive value returned by the
>> original freq_qos_update_request(). It just doesn't need to know whether the
>> effective policy has been updated or not, it only needs to make sure the
>> operations has been successful. Moreover the positive value is related only
>> to the !last! active policy, which doesn't give the caller a full picture
>> of the policy change anyway. So taking all of these into account I'd leave the
>> fix as is.
> Rafael: This function is called via a function pointer, which can call
> this or a platform dependent routine (like in acpi-cpufreq.c), and it
> would be reasonable IMO for the return of that callback to only look
> for 0 or negative values, as is generally done in the kernel.

But it only has one caller that can easily check ret < 0 instead of just 
ret, so the extra branch can be saved.

That said if you really only want it to return 0 on success, you may as 
well add a ret = 0; statement (with a comment explaining why it is 
needed) after the last break in the loop.

Cheers!


