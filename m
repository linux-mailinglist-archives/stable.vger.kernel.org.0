Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DEC72B661A
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 15:01:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732140AbgKQOBL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 09:01:11 -0500
Received: from mx07-00178001.pphosted.com ([185.132.182.106]:17386 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731126AbgKQOBK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Nov 2020 09:01:10 -0500
Received: from pps.filterd (m0046668.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AHDvZEd013952;
        Tue, 17 Nov 2020 15:00:35 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=STMicroelectronics;
 bh=jVvnEkcOSvoJYeMhxUbGozS73QUI6vmOLenEHz6g06g=;
 b=PV53Thje8eJpmKTSC2cAgUMoiFddEJyTaK/9fQINegu38IY7vRUIFI0+oEQe68cMI19o
 Sq0f0SLQjhlUsmSD+LIZZifim2jYCFDLswqi0OzPFQIYcctRMVMRdNA4aRlEaF6etNL6
 om7jCXTF4P6+fjNI71mjOhxaQb7u9tfLlzuOXpY0hkmKrDO3FakqSr+uMS97yfZhTJBU
 qdGO1kpKnzVIvhYuraB8vl/ADVgs3oBq5KeRoFRGqx+H0ISWPgh7U8Y80fVgiz0/rhq5
 VWxIq646yI60DUdZtJNOVZZDWG0th1TDV7SPU4tFiORSQJ024rKEZgwJbZ1UJ2J9dpOF hw== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 34t5k51mxd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 15:00:35 +0100
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id AA2FB10002A;
        Tue, 17 Nov 2020 15:00:33 +0100 (CET)
Received: from Webmail-eu.st.com (sfhdag3node1.st.com [10.75.127.7])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 6DD5B205D19;
        Tue, 17 Nov 2020 15:00:33 +0100 (CET)
Received: from lmecxl0889.lme.st.com (10.75.127.47) by SFHDAG3NODE1.st.com
 (10.75.127.7) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 17 Nov
 2020 15:00:32 +0100
Subject: Re: [PATCH virtio] virtio: virtio_console: fix DMA memory allocation
 for rproc serial
To:     Christoph Hellwig <hch@infradead.org>
CC:     Alexander Lobakin <alobakin@pm.me>, Amit Shah <amit@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Suman Anna <s-anna@ti.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-remoteproc@vger.kernel.org" <linux-remoteproc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <AOKowLclCbOCKxyiJ71WeNyuAAj2q8EUtxrXbyky5E@cp7-web-042.plabs.ch>
 <20201116091950.GA30524@infradead.org>
 <ca183081-5a9f-0104-bf79-5fea544c9271@st.com>
 <20201116162844.GB16619@infradead.org> <20201116163907.GA19209@infradead.org>
From:   Arnaud POULIQUEN <arnaud.pouliquen@st.com>
Message-ID: <79d2eb78-caad-9c0d-e130-51e628cedaaa@st.com>
Date:   Tue, 17 Nov 2020 15:00:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201116163907.GA19209@infradead.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.75.127.47]
X-ClientProxiedBy: SFHDAG2NODE2.st.com (10.75.127.5) To SFHDAG3NODE1.st.com
 (10.75.127.7)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-17_03:2020-11-17,2020-11-17 signatures=0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 11/16/20 5:39 PM, Christoph Hellwig wrote:
> Btw, I also still don't understand why remoteproc is using
> dma_declare_coherent_memory to start with.  The virtio code has exactly
> one call to dma_alloc_coherent vring_alloc_queue, a function that
> already switches between two different allocators.  Why can't we just
> add a third allocator specifically for these remoteproc memory carveouts
> and bypass dma_declare_coherent_memory entirely?
> 

The dma_declare_coherent_memory allows to associate vdev0buffer memory region
to the remoteproc virtio device (vdev parent). This region is used to allocated
the rpmsg buffers.
The memory for the rpmsg buffer is allocated by the rpmsg_virtio device in
rpmsg_virtio_bus[1]. The size depends on the total size needed for the rpmsg
buffers.

The vrings are allocated directly by the remoteproc device.

[1]
https://elixir.bootlin.com/linux/v5.10-rc3/source/drivers/rpmsg/virtio_rpmsg_bus.c#L925
