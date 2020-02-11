Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD0F15929C
	for <lists+stable@lfdr.de>; Tue, 11 Feb 2020 16:12:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728892AbgBKPMo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Feb 2020 10:12:44 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:57375 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728656AbgBKPMo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Feb 2020 10:12:44 -0500
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20200211151242euoutp01bf7b7b03b54379f403121d294c785aa9~yYc9RgwhY1073810738euoutp01l
        for <stable@vger.kernel.org>; Tue, 11 Feb 2020 15:12:42 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20200211151242euoutp01bf7b7b03b54379f403121d294c785aa9~yYc9RgwhY1073810738euoutp01l
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1581433962;
        bh=XOqiAj+KxXTOiFdPG5aON9T8QQbbeYYHqs5pA0A7o0w=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=oJA397X9cS2KOwfklhPfnrXyX9KiLbCzgrgJSFcfJkXspcTeN7pOSPpJVKFScSjG6
         UNU5wU4hc/VIvJ4C+5/3lExk/YTDM/8NJ17Ux2KYt5h2ZrAGeMul2t63Q1IZ4+5fxb
         dBi5rxymOSyqc9CKrPVcVLoJs13Qn53KETGLF8NM=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20200211151242eucas1p29d0b4ae6d04b51b0619dd28e91a14189~yYc9GOkis3000230002eucas1p2s;
        Tue, 11 Feb 2020 15:12:42 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 34.BB.60679.964C24E5; Tue, 11
        Feb 2020 15:12:42 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20200211151241eucas1p1a6afe8c8330f532f3d4115a4b61165c3~yYc83Qo681163111631eucas1p1e;
        Tue, 11 Feb 2020 15:12:41 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200211151241eusmtrp29199c38ffbc064cbd0617ed28f3a5f83~yYc82lCcd1658116581eusmtrp2U;
        Tue, 11 Feb 2020 15:12:41 +0000 (GMT)
X-AuditID: cbfec7f4-0e5ff7000001ed07-54-5e42c469de25
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 0F.B1.07950.964C24E5; Tue, 11
        Feb 2020 15:12:41 +0000 (GMT)
Received: from [106.120.51.15] (unknown [106.120.51.15]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200211151241eusmtip2457e2ca943f8db33e3c514d99c06acba~yYc8dQ8DE2983129831eusmtip2X;
        Tue, 11 Feb 2020 15:12:41 +0000 (GMT)
Subject: Re: [RFT PATCH v2] xhci: Fix memory leak when caching protocol
 extended capability PSI tables
To:     Mathias Nyman <mathias.nyman@linux.intel.com>,
        gregkh@linuxfoundation.org
Cc:     pmenzel@molgen.mpg.de, mika.westerberg@linux.intel.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, krzk@kernel.org,
        stable <stable@vger.kernel.org>
From:   Marek Szyprowski <m.szyprowski@samsung.com>
Message-ID: <da2d0387-47f8-e047-0ff8-d971072f9f89@samsung.com>
Date:   Tue, 11 Feb 2020 16:12:40 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
        Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200211150158.14475-1-mathias.nyman@linux.intel.com>
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAKsWRmVeSWpSXmKPExsWy7djPc7pZR5ziDM4LWjQvXs9mcf78BnaL
        y7vmsFnMOL+PyWLRslZmi9cfmlgspmw/wm7xclaaxYKNjxgdOD02repk85h3MtBj/9w17B5P
        zk1g9vi8SS6ANYrLJiU1J7MstUjfLoEr48/hCywFbwMrbrS0MzYwPrDvYuTkkBAwkVi06iMj
        iC0ksIJR4tP/9C5GLiD7C6PEsWn/mCESnxkl7t/n7WLkAGu4dkoVomY5o8TtVyvZIJy3jBJ3
        125iBWkQFsiQmP1lNjuILSLgL9H0YQcrSBGzwDlGicmdZ1hAEmwChhJdb7vYQKbyCthJXHqU
        DRJmEVCV+HvrEFiJqECsxJlj38Fm8goISpyc+QQszingLPGp+TxYnFlAXqJ562xmCFtc4taT
        +UwguyQEDrFLPDw5kwXiTReJ1WdvskLYwhKvjm9hh7BlJP7vhGloZpR4eG4tO4TTwyhxuWkG
        I0SVtcSdc7/ALmUW0JRYv0sfIuwosfvqWlZIsPBJ3HgrCHEEn8SkbdOZIcK8Eh1tQhDVahKz
        jq+DW3vwwiXmCYxKs5C8NgvJO7OQvDMLYe8CRpZVjOKppcW56anFRnmp5XrFibnFpXnpesn5
        uZsYgeno9L/jX3Yw7vqTdIhRgINRiYfXYbpTnBBrYllxZe4hRgkOZiURXktpxzgh3pTEyqrU
        ovz4otKc1OJDjNIcLErivMaLXsYKCaQnlqRmp6YWpBbBZJk4OKUaGJedSDd7kzHxpe9OOfWa
        pY+dJ55s/39oygs9ca782bevPo6oWPDPTWGtktN9OZ6GS4VsFY/OXpho0nNFWUo64lFEm5rH
        Ua38LaV2kl7cx3UtDBe/ThFJnLr3jwBL14Ksq70Prn9d3LDVb9FFv3Rua5az7Ymz3pkusWLi
        CdefM80vIlH07EruaiWW4oxEQy3mouJEAAmSs75DAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKIsWRmVeSWpSXmKPExsVy+t/xe7qZR5ziDE7s07FoXryezeL8+Q3s
        Fpd3zWGzmHF+H5PFomWtzBavPzSxWEzZfoTd4uWsNIsFGx8xOnB6bFrVyeYx72Sgx/65a9g9
        npybwOzxeZNcAGuUnk1RfmlJqkJGfnGJrVK0oYWRnqGlhZ6RiaWeobF5rJWRqZK+nU1Kak5m
        WWqRvl2CXsafwxdYCt4GVtxoaWdsYHxg38XIwSEhYCJx7ZRqFyMXh5DAUkaJ1n332boYOYHi
        MhInpzWwQtjCEn+udbFBFL1mlHj7qRusSFggQ2L2l9nsILaIgK/EhXlfmECKmAXOMUo8v7iK
        BaLjPKPE5UfHWECq2AQMJbregozi4OAVsJO49CgbJMwioCrx99YhsBJRgViJY9vbwIbyCghK
        nJz5BCzOKeAs8an5PNhFzAJmEvM2P2SGsOUlmrfOhrLFJW49mc80gVFoFpL2WUhaZiFpmYWk
        ZQEjyypGkdTS4tz03GIjveLE3OLSvHS95PzcTYzAKNx27OeWHYxd74IPMQpwMCrx8DpMd4oT
        Yk0sK67MPcQowcGsJMJrKe0YJ8SbklhZlVqUH19UmpNafIjRFOi5icxSosn5wASRVxJvaGpo
        bmFpaG5sbmxmoSTO2yFwMEZIID2xJDU7NbUgtQimj4mDU6qBcVv2txONklWcr9g4NyzSZ33c
        4lsvqbJg2YKESYdrLt2XsPru9OJv7oqw3dz/9dtkD3dPuOhi8PiKb3XMG3WXXa88MrInqtbw
        ZnkbzlAN93zAsqFIw6hg+oWXP14YP7aZFMQnf9C1bbGWx9cdH7mepW2YPt/0EpdDXs79u1yv
        c6eyLtquxWM3TYmlOCPRUIu5qDgRAFOrmX3YAgAA
X-CMS-MailID: 20200211151241eucas1p1a6afe8c8330f532f3d4115a4b61165c3
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20200211150022eucas1p1774275707908e4ee455291a793da308a
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200211150022eucas1p1774275707908e4ee455291a793da308a
References: <20d0559f-8d0f-42f5-5ebf-7f658a172161@linux.intel.com>
        <CGME20200211150022eucas1p1774275707908e4ee455291a793da308a@eucas1p1.samsung.com>
        <20200211150158.14475-1-mathias.nyman@linux.intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Mathias,

On 11.02.2020 16:01, Mathias Nyman wrote:
> xhci driver assumed that xHC controllers have at most one custom
> supported speed table (PSI) for all usb 3.x ports.
> Memory was allocated for one PSI table under the xhci hub structure.
>
> Turns out this is not the case, some controllers have a separate
> "supported protocol capability" entry with a PSI table for each port.
> This means each usb3 roothub port can in theory support different custom
> speeds.
>
> To solve this, cache all supported protocol capabilities with their PSI
> tables in an array, and add pointers to the xhci port structure so that
> every port points to its capability entry in the array.
>
> When creating the SuperSpeedPlus USB Device Capability BOS descriptor
> for the xhci USB 3.1 roothub we for now will use only data from the
> first USB 3.1 capable protocol capability entry in the array.
> This could be improved later, this patch focuses resolving
> the memory leak.
>
> Reported-by: Paul Menzel <pmenzel@molgen.mpg.de>
> Reported-by: Sajja Venkateswara Rao <VenkateswaraRao.Sajja@amd.com>
> Fixes: 47189098f8be ("xhci: parse xhci protocol speed ID list for usb 3.1 usage")
> Cc: stable <stable@vger.kernel.org> # v4.4+
> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>

Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>

> ---
>
> Changes since v1:
>
> - Clear xhci->num_port_caps in xhci_mem_cleanup()
>    Otherwise we fail to add new ports and cause NULL pointer dereference at
>    manual xhci re-initialization. This can happen at resume if host lost power
>    during suspend.
> ---
>   drivers/usb/host/xhci-hub.c | 25 +++++++++++-----
>   drivers/usb/host/xhci-mem.c | 59 +++++++++++++++++++++++--------------
>   drivers/usb/host/xhci.h     | 14 +++++++--
>   3 files changed, 65 insertions(+), 33 deletions(-)
>
> diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
> index 7a3a29e5e9d2..af92b2576fe9 100644
> --- a/drivers/usb/host/xhci-hub.c
> +++ b/drivers/usb/host/xhci-hub.c
> @@ -55,6 +55,7 @@ static u8 usb_bos_descriptor [] = {
>   static int xhci_create_usb3_bos_desc(struct xhci_hcd *xhci, char *buf,
>   				     u16 wLength)
>   {
> +	struct xhci_port_cap *port_cap = NULL;
>   	int i, ssa_count;
>   	u32 temp;
>   	u16 desc_size, ssp_cap_size, ssa_size = 0;
> @@ -64,16 +65,24 @@ static int xhci_create_usb3_bos_desc(struct xhci_hcd *xhci, char *buf,
>   	ssp_cap_size = sizeof(usb_bos_descriptor) - desc_size;
>   
>   	/* does xhci support USB 3.1 Enhanced SuperSpeed */
> -	if (xhci->usb3_rhub.min_rev >= 0x01) {
> +	for (i = 0; i < xhci->num_port_caps; i++) {
> +		if (xhci->port_caps[i].maj_rev == 0x03 &&
> +		    xhci->port_caps[i].min_rev >= 0x01) {
> +			usb3_1 = true;
> +			port_cap = &xhci->port_caps[i];
> +			break;
> +		}
> +	}
> +
> +	if (usb3_1) {
>   		/* does xhci provide a PSI table for SSA speed attributes? */
> -		if (xhci->usb3_rhub.psi_count) {
> +		if (port_cap->psi_count) {
>   			/* two SSA entries for each unique PSI ID, RX and TX */
> -			ssa_count = xhci->usb3_rhub.psi_uid_count * 2;
> +			ssa_count = port_cap->psi_uid_count * 2;
>   			ssa_size = ssa_count * sizeof(u32);
>   			ssp_cap_size -= 16; /* skip copying the default SSA */
>   		}
>   		desc_size += ssp_cap_size;
> -		usb3_1 = true;
>   	}
>   	memcpy(buf, &usb_bos_descriptor, min(desc_size, wLength));
>   
> @@ -99,7 +108,7 @@ static int xhci_create_usb3_bos_desc(struct xhci_hcd *xhci, char *buf,
>   	}
>   
>   	/* If PSI table exists, add the custom speed attributes from it */
> -	if (usb3_1 && xhci->usb3_rhub.psi_count) {
> +	if (usb3_1 && port_cap->psi_count) {
>   		u32 ssp_cap_base, bm_attrib, psi, psi_mant, psi_exp;
>   		int offset;
>   
> @@ -111,7 +120,7 @@ static int xhci_create_usb3_bos_desc(struct xhci_hcd *xhci, char *buf,
>   
>   		/* attribute count SSAC bits 4:0 and ID count SSIC bits 8:5 */
>   		bm_attrib = (ssa_count - 1) & 0x1f;
> -		bm_attrib |= (xhci->usb3_rhub.psi_uid_count - 1) << 5;
> +		bm_attrib |= (port_cap->psi_uid_count - 1) << 5;
>   		put_unaligned_le32(bm_attrib, &buf[ssp_cap_base + 4]);
>   
>   		if (wLength < desc_size + ssa_size)
> @@ -124,8 +133,8 @@ static int xhci_create_usb3_bos_desc(struct xhci_hcd *xhci, char *buf,
>   		 * USB 3.1 requires two SSA entries (RX and TX) for every link
>   		 */
>   		offset = desc_size;
> -		for (i = 0; i < xhci->usb3_rhub.psi_count; i++) {
> -			psi = xhci->usb3_rhub.psi[i];
> +		for (i = 0; i < port_cap->psi_count; i++) {
> +			psi = port_cap->psi[i];
>   			psi &= ~USB_SSP_SUBLINK_SPEED_RSVD;
>   			psi_exp = XHCI_EXT_PORT_PSIE(psi);
>   			psi_mant = XHCI_EXT_PORT_PSIM(psi);
> diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
> index 0e2701649369..884c601bfa15 100644
> --- a/drivers/usb/host/xhci-mem.c
> +++ b/drivers/usb/host/xhci-mem.c
> @@ -1915,17 +1915,17 @@ void xhci_mem_cleanup(struct xhci_hcd *xhci)
>   	xhci->usb3_rhub.num_ports = 0;
>   	xhci->num_active_eps = 0;
>   	kfree(xhci->usb2_rhub.ports);
> -	kfree(xhci->usb2_rhub.psi);
>   	kfree(xhci->usb3_rhub.ports);
> -	kfree(xhci->usb3_rhub.psi);
>   	kfree(xhci->hw_ports);
>   	kfree(xhci->rh_bw);
>   	kfree(xhci->ext_caps);
> +	for (i = 0; i < xhci->num_port_caps; i++)
> +		kfree(xhci->port_caps[i].psi);
> +	kfree(xhci->port_caps);
> +	xhci->num_port_caps = 0;
>   
>   	xhci->usb2_rhub.ports = NULL;
> -	xhci->usb2_rhub.psi = NULL;
>   	xhci->usb3_rhub.ports = NULL;
> -	xhci->usb3_rhub.psi = NULL;
>   	xhci->hw_ports = NULL;
>   	xhci->rh_bw = NULL;
>   	xhci->ext_caps = NULL;
> @@ -2126,6 +2126,7 @@ static void xhci_add_in_port(struct xhci_hcd *xhci, unsigned int num_ports,
>   	u8 major_revision, minor_revision;
>   	struct xhci_hub *rhub;
>   	struct device *dev = xhci_to_hcd(xhci)->self.sysdev;
> +	struct xhci_port_cap *port_cap;
>   
>   	temp = readl(addr);
>   	major_revision = XHCI_EXT_PORT_MAJOR(temp);
> @@ -2160,31 +2161,39 @@ static void xhci_add_in_port(struct xhci_hcd *xhci, unsigned int num_ports,
>   		/* WTF? "Valid values are ‘1’ to MaxPorts" */
>   		return;
>   
> -	rhub->psi_count = XHCI_EXT_PORT_PSIC(temp);
> -	if (rhub->psi_count) {
> -		rhub->psi = kcalloc_node(rhub->psi_count, sizeof(*rhub->psi),
> -				    GFP_KERNEL, dev_to_node(dev));
> -		if (!rhub->psi)
> -			rhub->psi_count = 0;
> +	port_cap = &xhci->port_caps[xhci->num_port_caps++];
> +	if (xhci->num_port_caps > max_caps)
> +		return;
> +
> +	port_cap->maj_rev = major_revision;
> +	port_cap->min_rev = minor_revision;
> +	port_cap->psi_count = XHCI_EXT_PORT_PSIC(temp);
> +
> +	if (port_cap->psi_count) {
> +		port_cap->psi = kcalloc_node(port_cap->psi_count,
> +					     sizeof(*port_cap->psi),
> +					     GFP_KERNEL, dev_to_node(dev));
> +		if (!port_cap->psi)
> +			port_cap->psi_count = 0;
>   
> -		rhub->psi_uid_count++;
> -		for (i = 0; i < rhub->psi_count; i++) {
> -			rhub->psi[i] = readl(addr + 4 + i);
> +		port_cap->psi_uid_count++;
> +		for (i = 0; i < port_cap->psi_count; i++) {
> +			port_cap->psi[i] = readl(addr + 4 + i);
>   
>   			/* count unique ID values, two consecutive entries can
>   			 * have the same ID if link is assymetric
>   			 */
> -			if (i && (XHCI_EXT_PORT_PSIV(rhub->psi[i]) !=
> -				  XHCI_EXT_PORT_PSIV(rhub->psi[i - 1])))
> -				rhub->psi_uid_count++;
> +			if (i && (XHCI_EXT_PORT_PSIV(port_cap->psi[i]) !=
> +				  XHCI_EXT_PORT_PSIV(port_cap->psi[i - 1])))
> +				port_cap->psi_uid_count++;
>   
>   			xhci_dbg(xhci, "PSIV:%d PSIE:%d PLT:%d PFD:%d LP:%d PSIM:%d\n",
> -				  XHCI_EXT_PORT_PSIV(rhub->psi[i]),
> -				  XHCI_EXT_PORT_PSIE(rhub->psi[i]),
> -				  XHCI_EXT_PORT_PLT(rhub->psi[i]),
> -				  XHCI_EXT_PORT_PFD(rhub->psi[i]),
> -				  XHCI_EXT_PORT_LP(rhub->psi[i]),
> -				  XHCI_EXT_PORT_PSIM(rhub->psi[i]));
> +				  XHCI_EXT_PORT_PSIV(port_cap->psi[i]),
> +				  XHCI_EXT_PORT_PSIE(port_cap->psi[i]),
> +				  XHCI_EXT_PORT_PLT(port_cap->psi[i]),
> +				  XHCI_EXT_PORT_PFD(port_cap->psi[i]),
> +				  XHCI_EXT_PORT_LP(port_cap->psi[i]),
> +				  XHCI_EXT_PORT_PSIM(port_cap->psi[i]));
>   		}
>   	}
>   	/* cache usb2 port capabilities */
> @@ -2219,6 +2228,7 @@ static void xhci_add_in_port(struct xhci_hcd *xhci, unsigned int num_ports,
>   			continue;
>   		}
>   		hw_port->rhub = rhub;
> +		hw_port->port_cap = port_cap;
>   		rhub->num_ports++;
>   	}
>   	/* FIXME: Should we disable ports not in the Extended Capabilities? */
> @@ -2309,6 +2319,11 @@ static int xhci_setup_port_arrays(struct xhci_hcd *xhci, gfp_t flags)
>   	if (!xhci->ext_caps)
>   		return -ENOMEM;
>   
> +	xhci->port_caps = kcalloc_node(cap_count, sizeof(*xhci->port_caps),
> +				flags, dev_to_node(dev));
> +	if (!xhci->port_caps)
> +		return -ENOMEM;
> +
>   	offset = cap_start;
>   
>   	while (offset) {
> diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
> index 13d8838cd552..3ecee10fdcdc 100644
> --- a/drivers/usb/host/xhci.h
> +++ b/drivers/usb/host/xhci.h
> @@ -1702,12 +1702,20 @@ struct xhci_bus_state {
>    * Intel Lynx Point LP xHCI host.
>    */
>   #define	XHCI_MAX_REXIT_TIMEOUT_MS	20
> +struct xhci_port_cap {
> +	u32			*psi;	/* array of protocol speed ID entries */
> +	u8			psi_count;
> +	u8			psi_uid_count;
> +	u8			maj_rev;
> +	u8			min_rev;
> +};
>   
>   struct xhci_port {
>   	__le32 __iomem		*addr;
>   	int			hw_portnum;
>   	int			hcd_portnum;
>   	struct xhci_hub		*rhub;
> +	struct xhci_port_cap	*port_cap;
>   };
>   
>   struct xhci_hub {
> @@ -1719,9 +1727,6 @@ struct xhci_hub {
>   	/* supported prococol extended capabiliy values */
>   	u8			maj_rev;
>   	u8			min_rev;
> -	u32			*psi;	/* array of protocol speed ID entries */
> -	u8			psi_count;
> -	u8			psi_uid_count;
>   };
>   
>   /* There is one xhci_hcd structure per controller */
> @@ -1880,6 +1885,9 @@ struct xhci_hcd {
>   	/* cached usb2 extened protocol capabilites */
>   	u32                     *ext_caps;
>   	unsigned int            num_ext_caps;
> +	/* cached extended protocol port capabilities */
> +	struct xhci_port_cap	*port_caps;
> +	unsigned int		num_port_caps;
>   	/* Compliance Mode Recovery Data */
>   	struct timer_list	comp_mode_recovery_timer;
>   	u32			port_status_u0;

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

