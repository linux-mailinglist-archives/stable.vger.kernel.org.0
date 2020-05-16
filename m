Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C92CC1D60F3
	for <lists+stable@lfdr.de>; Sat, 16 May 2020 14:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726254AbgEPMwK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 May 2020 08:52:10 -0400
Received: from mail.baikalelectronics.com ([87.245.175.226]:40058 "EHLO
        mail.baikalelectronics.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726237AbgEPMwK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 16 May 2020 08:52:10 -0400
Received: from localhost (unknown [127.0.0.1])
        by mail.baikalelectronics.ru (Postfix) with ESMTP id 43AD88030802;
        Sat, 16 May 2020 12:52:07 +0000 (UTC)
X-Virus-Scanned: amavisd-new at baikalelectronics.ru
Received: from mail.baikalelectronics.ru ([127.0.0.1])
        by localhost (mail.baikalelectronics.ru [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id PpvYz0io-J5L; Sat, 16 May 2020 15:52:05 +0300 (MSK)
Date:   Sat, 16 May 2020 15:52:03 +0300
From:   Serge Semin <Sergey.Semin@baikalelectronics.ru>
To:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
CC:     Serge Semin <fancer.lancer@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Paul Burton <paulburton@kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <robh+dt@kernel.org>, <linux-mips@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <stable@vger.kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Yue Hu <huyue2@yulong.com>,
        <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 20/20] cpufreq: Return zero on success in boost sw
 setting
Message-ID: <20200516125203.et5gkv6ullkerjyd@mobilestation>
References: <20200306124807.3596F80307C2@mail.baikalelectronics.ru>
 <20200506174238.15385-1-Sergey.Semin@baikalelectronics.ru>
 <20200506174238.15385-21-Sergey.Semin@baikalelectronics.ru>
 <c5109483-4c14-1a0c-efa9-51edf01c12de@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <c5109483-4c14-1a0c-efa9-51edf01c12de@intel.com>
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Rafael,

On Fri, May 15, 2020 at 05:58:47PM +0200, Rafael J. Wysocki wrote:
> On 5/6/2020 7:42 PM, Sergey.Semin@baikalelectronics.ru wrote:
> > From: Serge Semin <Sergey.Semin@baikalelectronics.ru>
> > 
> > Recent commit e61a41256edf ("cpufreq: dev_pm_qos_update_request() can
> > return 1 on success") fixed a problem when active policies traverse
> > was falsely stopped due to invalidly treating the non-zero return value
> > from freq_qos_update_request() method as an error. Yes, that function
> > can return positive values if the requested update actually took place.
> > The current problem is that the returned value is then passed to the
> > return cell of the cpufreq_boost_set_sw() (set_boost callback) method.
> > This value is then also analyzed for being non-zero, which is also
> > treated as having an error. As a result during the boost activation
> > we'll get an error returned while having the QOS frequency update
> > successfully performed. Fix this by returning a negative value from the
> > cpufreq_boost_set_sw() if actual error was encountered and zero
> > otherwise treating any positive values as the successful operations
> > completion.
> > 
> > Fixes: 18c49926c4bf ("cpufreq: Add QoS requests for userspace constraints")
> > Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
> > Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
> > Cc: Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>
> > Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> > Cc: Paul Burton <paulburton@kernel.org>
> > Cc: Ralf Baechle <ralf@linux-mips.org>
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Cc: Rob Herring <robh+dt@kernel.org>
> > Cc: linux-mips@vger.kernel.org
> > Cc: devicetree@vger.kernel.org
> > Cc: stable@vger.kernel.org
> > ---
> >   drivers/cpufreq/cpufreq.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> > index 045f9fe157ce..5870cdca88cf 100644
> > --- a/drivers/cpufreq/cpufreq.c
> > +++ b/drivers/cpufreq/cpufreq.c
> > @@ -2554,7 +2554,7 @@ static int cpufreq_boost_set_sw(int state)
> >   			break;
> >   	}
> > -	return ret;
> > +	return ret < 0 ? ret : 0;
> >   }
> >   int cpufreq_boost_trigger_state(int state)
> 
> IMO it is better to update the caller of this function to handle the
> positive value possibly returned by it correctly.

Could you elaborate why? Viresh seems to be ok with this solution.

As I see it the caller doesn't expect the positive value returned by the
original freq_qos_update_request(). It just doesn't need to know whether the
effective policy has been updated or not, it only needs to make sure the
operations has been successful. Moreover the positive value is related only
to the !last! active policy, which doesn't give the caller a full picture
of the policy change anyway. So taking all of these into account I'd leave the
fix as is.

Regards,
-Sergey

> 
> Thanks!
> 
> 
