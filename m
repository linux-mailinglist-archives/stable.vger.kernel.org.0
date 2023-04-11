Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B3176DD774
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 12:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229452AbjDKKGi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 06:06:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbjDKKGL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 06:06:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A27D3C3B
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 03:05:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681207512;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MQJyPgI1aYYzA2uRs3ijvvK+cnKO4iZfEOcreRoPXjs=;
        b=dZ1ALtNfGMDvbpae11AC+3j3x70FCEIPfXMibPhUV6givTasDbma9MNsFeS6dBColYB8P7
        d/iyK5Bz6d68W+ocibYz14LiMDCMKXfd2MyGv0HhQYqf7WvexBsu8M6QQSavzHtlhQn4Nm
        cp3oigzjNijPZYF5NsG1GeCyem7AxTw=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-128-d1VgTJfpPs-DnuWm_oOvZg-1; Tue, 11 Apr 2023 06:05:11 -0400
X-MC-Unique: d1VgTJfpPs-DnuWm_oOvZg-1
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-5ea572ef499so4353996d6.1
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 03:05:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681207511; x=1683799511;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MQJyPgI1aYYzA2uRs3ijvvK+cnKO4iZfEOcreRoPXjs=;
        b=asmzkKDln7kN5RVQYbp0/lfUiDBJ2FJOaFl3R94Ht2L9vlP6pRgLhUTXDDe323+gn8
         6aLAHN5+fDyJxdw+pHXsbEerw5KI4sVA5nmTBFj+PeDwkt7Zx7AIsukbF0kwcLqOmWkR
         aqJeVHJlqJeg2IMin3CDoZ7EF38P6QpWhxoyp3w0marlNHHl88M4A3r4sh+OSGdB+AUY
         9chjKrz1DvUewaa0Ajicl0jWXCcEA3sZtAEp92xZYS36prjeKTN6xrF6VtWBAe1udtR1
         ATG6zn1snu6i5qmeR8TsAw5g1IssgiA4gJlGQIILm+dKNDP3pMflDq+cwLIZz4N5SvUX
         BapA==
X-Gm-Message-State: AAQBX9ecbu22e9J+Z440FHVDyY/ngUmw9Xl9xe4fU3vj+75DNP0NqWVS
        MbqvbI5a37UqqhxrBwyrERv/sJPY7wUTmv/unPUWh15TnbC0zTsrVRV/ITTc7AdhYA4cnfCV9M4
        R5NRm4qLfLmqdg6Rl
X-Received: by 2002:a05:6214:c2f:b0:5e0:84a9:2927 with SMTP id a15-20020a0562140c2f00b005e084a92927mr21797621qvd.4.1681207510953;
        Tue, 11 Apr 2023 03:05:10 -0700 (PDT)
X-Google-Smtp-Source: AKy350YmLFiGBKxZDQs5rlvP04KZi2wea8aPk/MtNoc+mqDg0UQ3dbzvIp555xXOrBZYvyYg8te9XA==
X-Received: by 2002:a05:6214:c2f:b0:5e0:84a9:2927 with SMTP id a15-20020a0562140c2f00b005e084a92927mr21797594qvd.4.1681207510694;
        Tue, 11 Apr 2023 03:05:10 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-239-96.dyn.eolo.it. [146.241.239.96])
        by smtp.gmail.com with ESMTPSA id y7-20020a0ce807000000b005e96ebf9bbdsm2443728qvn.5.2023.04.11.03.05.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 03:05:10 -0700 (PDT)
Message-ID: <e8b3646710d5fbedbe73449e5a1a7bd83fb1fa61.camel@redhat.com>
Subject: Re: [PATCH net] net: phy: nxp-c45-tja11xx: add remove callback
From:   Paolo Abeni <pabeni@redhat.com>
To:     "Radu Pirea (OSS)" <radu-nicolae.pirea@oss.nxp.com>,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Date:   Tue, 11 Apr 2023 12:05:07 +0200
In-Reply-To: <20230406095904.75456-1-radu-nicolae.pirea@oss.nxp.com>
References: <20230406095904.75456-1-radu-nicolae.pirea@oss.nxp.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2023-04-06 at 12:59 +0300, Radu Pirea (OSS) wrote:
> Unregister PTP clock when the driver is removed.
> Purge the RX and TX skb queues.
>=20
> Fixes: 514def5dd339 ("phy: nxp-c45-tja11xx: add timestamping support")
> CC: stable@vger.kernel.org # 5.15+
> Signed-off-by: Radu Pirea (OSS) <radu-nicolae.pirea@oss.nxp.com>

Andrew: my understanding is that a connected phy, maintains a reference
to the relevant driver via phydev->mdio.dev.driver->owner, and such
reference is dropped by phy_disconnect() via phy_detach().

So remove can invoked only after phy_disconnect

Does the above sounds reasonable/answer your question?

Thanks

Paolo

