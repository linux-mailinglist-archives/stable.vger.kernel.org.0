Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AEC14DDCAF
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 16:22:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237916AbiCRPXn convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 18 Mar 2022 11:23:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236563AbiCRPXm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Mar 2022 11:23:42 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 865F326240D
        for <stable@vger.kernel.org>; Fri, 18 Mar 2022 08:22:23 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-150-J-EB7TRUPCa955UakG2Ikg-1; Fri, 18 Mar 2022 15:22:20 +0000
X-MC-Unique: J-EB7TRUPCa955UakG2Ikg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.32; Fri, 18 Mar 2022 15:22:20 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.033; Fri, 18 Mar 2022 15:22:20 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Juergen Gross' <jgross@suse.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "platform-driver-x86@vger.kernel.org" 
        <platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Dell.Client.Kernel@dell.com" <Dell.Client.Kernel@dell.com>
CC:     Stuart Hayes <stuart.w.hayes@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] platform/x86/dell: add buffer allocation/free functions
 for SMI calls
Thread-Topic: [PATCH] platform/x86/dell: add buffer allocation/free functions
 for SMI calls
Thread-Index: AQHYOto/hyLOp/NEJ0S+JLWvPC30KazFQPKg
Date:   Fri, 18 Mar 2022 15:22:19 +0000
Message-ID: <accf95548a8c4374b17c159b9b2d0098@AcuMS.aculab.com>
References: <20220318150950.16843-1-jgross@suse.com>
In-Reply-To: <20220318150950.16843-1-jgross@suse.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross
> Sent: 18 March 2022 15:10
> 
> The dcdbas driver is used to call SMI handlers for both, dcdbas and
> dell-smbios-smm. Both drivers allocate a buffer for communicating
> with the SMI handler. The physical buffer address is then passed to
> the called SMI handler via %ebx.
> 
> Unfortunately this doesn't work when running in Xen dom0, as the
> physical address obtained via virt_to_phys() is only a guest physical
> address, and not a machine physical address as needed by SMI.

The physical address from virt_to_phy() is always wrong.
That is the physical address the cpu has for the memory.
What you want is the address the dma master interface needs to use.
That can be different for a physical system - no need for virtualisation.

On x86 they do usually match, but anything with a full iommu
will need completely different addresses.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

