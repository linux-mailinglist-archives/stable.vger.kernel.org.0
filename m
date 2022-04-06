Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 217644F5FAA
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 15:30:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233013AbiDFNRT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 09:17:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232343AbiDFNRL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 09:17:11 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A7234E7D9A
        for <stable@vger.kernel.org>; Wed,  6 Apr 2022 02:54:56 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id m30so2396510wrb.1
        for <stable@vger.kernel.org>; Wed, 06 Apr 2022 02:54:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HDhSTbbW7xXt8kqWzs+odsHOCgWSTvr/1d4TircSL8c=;
        b=Cglbp+8erWtMAybQPfgniVDgULgXV1FIx2lWhh+ndRv6/yVS1vEfPpBl1540hb/ZWx
         ed2pDH3hC5bVypVktwiakQhNiKHQq8dVv+7UoHSlHGU/9bzBRq6UsxCefVE0M4M0PG8U
         q/2MChgohk86gzizfoe/v7QpjKiUkUK1NNtkgyfBCnIHLuibobUhp3WGWx3bdS9/+AZc
         LPVb6ZbTZT2dYgRYioRlZybpIWfu14pv3YDHgvre2kiYFmGgFfO7l/6gb6oJPvi0r+E+
         zi5DAQYDN8H/dsOz7Ej/3iRoUmUi/Vr7MZytFGPK6NYsgnK7XcCqSTaFiocpVW9OMGS3
         wrlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HDhSTbbW7xXt8kqWzs+odsHOCgWSTvr/1d4TircSL8c=;
        b=IXYuPfEIAllSlG3mhl9gZhsA4iGR1oetE/H+18L1eh/c1ysbWeROgg1kZMqnk/sI47
         b4jpY2GyGGuFskrLAke1omiJ3DIfZepm1Un4MKhnDyluL38mmB8NGdQosablVBDOLAeI
         HWSogHNLP6GmDzCw2N0JXik3r87v8lofhyQDo1gR5nmMEg5M7rygnD3taVt2Kwe2YiZL
         tbyXKPm4PMp/0raHQFX+DliPejPYWtps6udLQAk5E1it2uK2INLW1YpUs5m3bTA+dp5r
         UoF0vPFE32qCyYytnIEJAid+iW7TLouhajhCM+3ewIFWeoJIW33nlEVYXeV7WPrBu6Ne
         pvmA==
X-Gm-Message-State: AOAM533MNtmR7vhFzorJhQkn2LETCBpo2ergVVdFHewZc1Zq3OyDWXIw
        vhCf6X6gcbZauDeLnFRo5FWPfw==
X-Google-Smtp-Source: ABdhPJzVecx24aeX/XIXr3Kiz4wmki4YASU5CCzxkxqXdEV7PZeWLJ04FsCtb5yIhRTgAPsBatD8pQ==
X-Received: by 2002:a5d:64c4:0:b0:206:10e0:d73b with SMTP id f4-20020a5d64c4000000b0020610e0d73bmr5787095wri.412.1649238782416;
        Wed, 06 Apr 2022 02:53:02 -0700 (PDT)
Received: from gojira.dev.6wind.com ([185.13.181.2])
        by smtp.gmail.com with ESMTPSA id f18-20020a5d6652000000b001e669ebd528sm13874604wrw.91.2022.04.06.02.53.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 02:53:01 -0700 (PDT)
From:   Olivier Matz <olivier.matz@6wind.com>
To:     netdev@vger.kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, intel-wired-lan@osuosl.org,
        Paul Menzel <pmenzel@molgen.mpg.de>, stable@vger.kernel.org,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH net v2 0/2] ixgbe: fix promiscuous mode on VF
Date:   Wed,  6 Apr 2022 11:52:50 +0200
Message-Id: <20220406095252.22338-1-olivier.matz@6wind.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

These 2 patches fix issues related to the promiscuous mode on VF.

Comments are welcome,
Olivier

Cc: stable@vger.kernel.org
Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>

Changes since v1:
- resend with CC intel-wired-lan
- remove CC Hiroshi Shimamoto (address does not exist anymore)

Olivier Matz (2):
  ixgbe: fix bcast packets Rx on VF after promisc removal
  ixgbe: fix unexpected VLAN Rx in promisc mode on VF

 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

-- 
2.30.2

