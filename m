Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15034458E48
	for <lists+stable@lfdr.de>; Mon, 22 Nov 2021 13:27:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236060AbhKVMa0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Nov 2021 07:30:26 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:30600 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234322AbhKVMa0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Nov 2021 07:30:26 -0500
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20211122122718euoutp012aeb948fe8281a029391054ee622ca92~53gG5Cf4z2760627606euoutp01N
        for <stable@vger.kernel.org>; Mon, 22 Nov 2021 12:27:18 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20211122122718euoutp012aeb948fe8281a029391054ee622ca92~53gG5Cf4z2760627606euoutp01N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1637584038;
        bh=iRB3UxxK1Di6aCE2Ld9HGZTPjw6VdP4WaBATR6RbZAY=;
        h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
        b=SUR8jR4RPuAzINL/TbTWk9H/OybVi1/Gb1V0+0tfjIGpFffIa8ETwM1O2V1JWyEAf
         mA1sUH8Te1lLJ1+sVS6X5hXyx4qzIZz84ij2sZIlpZmKP4tYA5rMJS6RwJh8U1zmD8
         qLlVoHoXCh/Hu6CLPJ3Yl/MosgMRbMnayD1/mkhI=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20211122122718eucas1p299d54d88fcd74fc00ea1439ab6266657~53gGn8o8I3260632606eucas1p2G;
        Mon, 22 Nov 2021 12:27:18 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 24.95.09887.5AC8B916; Mon, 22
        Nov 2021 12:27:18 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20211122122717eucas1p17574c005b04a3c50cb9e94aa729652e8~53gGJpAPz2989829898eucas1p1f;
        Mon, 22 Nov 2021 12:27:17 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20211122122717eusmtrp207f0989d53e196f9a73a883cc5e0a66c~53gGDN1-g2893128931eusmtrp2H;
        Mon, 22 Nov 2021 12:27:17 +0000 (GMT)
X-AuditID: cbfec7f4-45bff7000000269f-86-619b8ca51ec7
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 58.8C.09522.5AC8B916; Mon, 22
        Nov 2021 12:27:17 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20211122122717eusmtip1b4d2b34c9995dc1266e98900cdf79bee~53gFmBlKU2119121191eusmtip1Q;
        Mon, 22 Nov 2021 12:27:17 +0000 (GMT)
Message-ID: <22f12ed7-18f3-9800-3858-9738f9ccd1f2@samsung.com>
Date:   Mon, 22 Nov 2021 13:27:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0)
        Gecko/20100101 Thunderbird/91.3.1
Subject: Re: [RFT PATCH] usb: hub: Fix locking issues with address0_mutex
Content-Language: en-US
To:     Mathias Nyman <mathias.nyman@linux.intel.com>,
        gregkh@linuxfoundation.org, stern@rowland.harvard.edu,
        kishon@ti.com
Cc:     hdegoede@redhat.com, chris.chiu@canonical.com,
        linux-usb@vger.kernel.org, stable@vger.kernel.org
From:   Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <20211122105003.1089218-1-mathias.nyman@linux.intel.com>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNKsWRmVeSWpSXmKPExsWy7djPc7rLemYnGhx9zWRxae1eVovmxevZ
        LN4cn85kceFpD5vFomWtzBavPzSxWCzY+IjRYsLvC2wOHB6zGnrZPOadDPTYP3cNu8f7fVfZ
        PGbf/cHocfzGdiaPz5vkAtijuGxSUnMyy1KL9O0SuDIaf05gLNgqW9E1eTNjA+Nq8S5GTg4J
        AROJtZ+a2EFsIYEVjBKLTsh2MXIB2V8YJc6+usQC4XxmlGjbeYsVpuP36pnMEInljBJdj76z
        QbR/ZJSYtMkSxOYVsJN403+AGcRmEVCVaHj/lQ0iLihxcuYTFhBbVCBJ4nTrJLAaYQFPib8L
        r4LFmQXEJW49mc8EYosIVEp0Luhkg4inSexoXAhWzyZgKNH1tgsszingKtH97TpUr7zE9rdz
        wI6TEHjDIXF/wjw2iKtdJBZcnwf1gbDEq+Nb2CFsGYn/O0GWgTQ0M0o8PLeWHcLpYZS43DSD
        EaLKWuLOuV9AkziAVmhKrN+lDxF2lJi3ro8dJCwhwCdx460gxBF8EpO2TWeGCPNKdLQJQVSr
        Scw6vg5u7cELl5gnMCrNQgqWWUjen4XknVkIexcwsqxiFE8tLc5NTy02ykst1ytOzC0uzUvX
        S87P3cQITE+n/x3/soNx+auPeocYmTgYDzFKcDArifBybJieKMSbklhZlVqUH19UmpNafIhR
        moNFSZxX5E9DopBAemJJanZqakFqEUyWiYNTqoFJ5LeT5cWHL4vf8/1+W7BT8M2dan+N1ylp
        oi9Kz8penFm7jb0/dPl+Gd0Vyz8vXf0nz22V11rF1/q2vPt/MCyb6iV/05R91cYDIl+Fb+cq
        cdXsuirh+/+ruJvrjO2NJxsfP2v/ZPt/oYDRisjut5f6pA9PPijn+uri0TWy0r6t1vN8777h
        bs9Z0bjn0Lrm8msXTn0NEJqtOC9HpMVPTsogZOnB5rC5Gdl176/XnZBYx6ZSrDbR4M1h5mMO
        1hPr7pccWqYlUCTLGsgn2b0+lt9uEqvFTfm2/zVP0r2cS3q25De6HmuY81Y6eNabTkGxd9w3
        1/R/ENi8R9Lm0Xy3tzsVHQ84iyzSbLjs1Jak6nNCiaU4I9FQi7moOBEA9RaBRr4DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPIsWRmVeSWpSXmKPExsVy+t/xu7pLe2YnGpy+IG9xae1eVovmxevZ
        LN4cn85kceFpD5vFomWtzBavPzSxWCzY+IjRYsLvC2wOHB6zGnrZPOadDPTYP3cNu8f7fVfZ
        PGbf/cHocfzGdiaPz5vkAtij9GyK8ktLUhUy8otLbJWiDS2M9AwtLfSMTCz1DI3NY62MTJX0
        7WxSUnMyy1KL9O0S9DIaf05gLNgqW9E1eTNjA+Nq8S5GTg4JAROJ36tnMncxcnEICSxllOi4
        +40dIiEjcXJaAyuELSzx51oXG0TRe0aJnaffMoMkeAXsJN70HwCzWQRUJRref2WDiAtKnJz5
        hAXEFhVIkuj/vgusRljAU+LvwqtgcWYBcYlbT+YzgdgiApUSWxofMkHE0yQubWtgh1h2kVHi
        2uvdYM1sAoYSXW+7wBZwCrhKdH+7DjXITKJraxcjhC0vsf3tHOYJjEKzkNwxC8m+WUhaZiFp
        WcDIsopRJLW0ODc9t9hQrzgxt7g0L10vOT93EyMwJrcd+7l5B+O8Vx/1DjEycTAeYpTgYFYS
        4eXYMD1RiDclsbIqtSg/vqg0J7X4EKMpMDAmMkuJJucDk0JeSbyhmYGpoYmZpYGppZmxkjiv
        Z0FHopBAemJJanZqakFqEUwfEwenVAPT3H1fdu0zK+wTn37pp5RdxU2zffVd692Xhu+0DunV
        eLlqwf0uhTCZ2RkS3ip9k47sOplj06T+5K7V+syM+kzDvCvPY0MOxwosTGK6cNo2N/7h6SVT
        1vhtPlFo46RdyM7N1VxQyml6dI79jNvW85xk2DpUNrccULofdLXrpvsCKVeTiwV9hSZWNw8v
        F3x43NzuucCjHWprX97rP6SzkdVy0auy8isC/GHMt7qLfHef2x9TN5vve73vEu8rN5oTTG6a
        brnDGt6irsW25Oru/4cM7Wz/rWysYH144bl1wI7LPF4uBe9Dy2qVk3imPQrX2fntwP9fLm9/
        8M/6e0Cu9OLCdvl9OowOu+TbhG5+6wxUYinOSDTUYi4qTgQA6q1DP1IDAAA=
X-CMS-MailID: 20211122122717eucas1p17574c005b04a3c50cb9e94aa729652e8
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20211122104844eucas1p193f1cdbe6255ccd2f945726711e719a4
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20211122104844eucas1p193f1cdbe6255ccd2f945726711e719a4
References: <1d6ef5ff-e5e2-b81e-42be-7876b5bcfd05@linux.intel.com>
        <CGME20211122104844eucas1p193f1cdbe6255ccd2f945726711e719a4@eucas1p1.samsung.com>
        <20211122105003.1089218-1-mathias.nyman@linux.intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 22.11.2021 11:50, Mathias Nyman wrote:
> Fix the circular lock dependency and unbalanced unlock of addess0_mutex
> introduced when fixing an address0_mutex enumeration retry race in commit
> ae6dc22d2d1 ("usb: hub: Fix usb enumeration issue due to address0 race")
>
> Make sure locking order between port_dev->status_lock and address0_mutex
> is correct, and that address0_mutex is not unlocked in hub_port_connect
> "done:" codepath which may be reached without locking address0_mutex
>
> Fixes: 6ae6dc22d2d1 ("usb: hub: Fix usb enumeration issue due to address0 race")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
This fixes the issue I've reported here: 
https://lore.kernel.org/all/f3bfcbc7-f701-c74a-09bd-6491d4c8d863@samsung.com/
Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>   drivers/usb/core/hub.c | 20 ++++++++++++--------
>   1 file changed, 12 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
> index 00c3506324e4..00070a8a6507 100644
> --- a/drivers/usb/core/hub.c
> +++ b/drivers/usb/core/hub.c
> @@ -5188,6 +5188,7 @@ static void hub_port_connect(struct usb_hub *hub, int port1, u16 portstatus,
>   	struct usb_port *port_dev = hub->ports[port1 - 1];
>   	struct usb_device *udev = port_dev->child;
>   	static int unreliable_port = -1;
> +	bool retry_locked;
>   
>   	/* Disconnect any existing devices under this port */
>   	if (udev) {
> @@ -5244,10 +5245,10 @@ static void hub_port_connect(struct usb_hub *hub, int port1, u16 portstatus,
>   
>   	status = 0;
>   
> -	mutex_lock(hcd->address0_mutex);
> -
>   	for (i = 0; i < PORT_INIT_TRIES; i++) {
> -
> +		usb_lock_port(port_dev);
> +		mutex_lock(hcd->address0_mutex);
> +		retry_locked = true;
>   		/* reallocate for each attempt, since references
>   		 * to the previous one can escape in various ways
>   		 */
> @@ -5255,6 +5256,8 @@ static void hub_port_connect(struct usb_hub *hub, int port1, u16 portstatus,
>   		if (!udev) {
>   			dev_err(&port_dev->dev,
>   					"couldn't allocate usb_device\n");
> +			mutex_unlock(hcd->address0_mutex);
> +			usb_unlock_port(port_dev);
>   			goto done;
>   		}
>   
> @@ -5276,13 +5279,13 @@ static void hub_port_connect(struct usb_hub *hub, int port1, u16 portstatus,
>   		}
>   
>   		/* reset (non-USB 3.0 devices) and get descriptor */
> -		usb_lock_port(port_dev);
>   		status = hub_port_init(hub, udev, port1, i);
> -		usb_unlock_port(port_dev);
>   		if (status < 0)
>   			goto loop;
>   
>   		mutex_unlock(hcd->address0_mutex);
> +		usb_unlock_port(port_dev);
> +		retry_locked = false;
>   
>   		if (udev->quirks & USB_QUIRK_DELAY_INIT)
>   			msleep(2000);
> @@ -5372,11 +5375,14 @@ static void hub_port_connect(struct usb_hub *hub, int port1, u16 portstatus,
>   
>   loop_disable:
>   		hub_port_disable(hub, port1, 1);
> -		mutex_lock(hcd->address0_mutex);
>   loop:
>   		usb_ep0_reinit(udev);
>   		release_devnum(udev);
>   		hub_free_dev(udev);
> +		if (retry_locked) {
> +			mutex_unlock(hcd->address0_mutex);
> +			usb_unlock_port(port_dev);
> +		}
>   		usb_put_dev(udev);
>   		if ((status == -ENOTCONN) || (status == -ENOTSUPP))
>   			break;
> @@ -5399,8 +5405,6 @@ static void hub_port_connect(struct usb_hub *hub, int port1, u16 portstatus,
>   	}
>   
>   done:
> -	mutex_unlock(hcd->address0_mutex);
> -
>   	hub_port_disable(hub, port1, 1);
>   	if (hcd->driver->relinquish_port && !hub->hdev->parent) {
>   		if (status != -ENOTCONN && status != -ENODEV)

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

