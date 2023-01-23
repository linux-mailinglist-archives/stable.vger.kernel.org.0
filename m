Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE410678513
	for <lists+stable@lfdr.de>; Mon, 23 Jan 2023 19:40:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232729AbjAWSkD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 13:40:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232012AbjAWSkC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 13:40:02 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 600DF241ED
        for <stable@vger.kernel.org>; Mon, 23 Jan 2023 10:40:01 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id b9-20020a170903228900b00194a0110d7bso7566472plh.6
        for <stable@vger.kernel.org>; Mon, 23 Jan 2023 10:40:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bN8JvZ9hp8tuola9y1jeIFB84hc7FTQzabUJBM21sv4=;
        b=VdRkRSZOSO2Pw83rSgomIRmzdUd/wRXtowUAj21MTs86PAzrSnmBXR+vB9Bn7Wncq+
         y3FiPTruc1+E6GlWEY2PNG7EIUP/RXuxAQ0qr7fr9R26ZRISL1ZtoDkBkZujqeEzbPvR
         QCkBaL6yHkHddAPnpPOXY6WiTCctr90L4TFChyD+XncekLmAu1rxqLDNtUb5ExD6X9vk
         wzLgm/KUtTUoNZpDyT3I/hxe9a28y+Sb3bA89qThnUD7IyijQP+EIa9XNTwJMB/81LHX
         Es2lsKIRb4EVlIui2Vv50T2PgvEfs0f4/uUbfef7P+dyzvSwMtxi4SkzLstRUMbSBBF8
         1X1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bN8JvZ9hp8tuola9y1jeIFB84hc7FTQzabUJBM21sv4=;
        b=HpnBAXLRTyOqyAH/t7se+g9N/ARshBZ429vkAWXa/Gn1bXSB2LShdVKw7nn2giU+xM
         P1TReH6YRQd6T7mKUM2RglEiZ8kwhQLJFxA8ART1rq9YcHm0+8YbuYSsyySQ6agfKgdj
         airKJlO/WTCb4IbVicdRKK9+XrtBqvkUuq1HEolgEsO/TqK3hnb2E4K0kGrhg/CFRQzL
         0CbXN2G/UawEnvz1SirH28wNxCF68yDtr7aIxo8LCS030Q4omTZvzpUXZ9YuoIsE25n2
         x/I/CUxe/IA3a4i3dNg/wGh0vi3TuyDLVFwr5HoRay85pHpa6D5TuBJClzOQfj9BRlFS
         oMvg==
X-Gm-Message-State: AO0yUKX+npyQOiwB1RBSgYxc/cBpCcJTW7QzIpW+WhJ1/skE70xOrJc8
        CvqTRLM0oJJThtNr2v0yN6LBEeU=
X-Google-Smtp-Source: AK7set+bQAfcJ5dAv95dxrMMN85wSEUYHR31H/QuLejvqZO2FBFtGy+zppANv4kIO14bIka/luzEXyE=
X-Received: from hmarynka.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:925])
 (user=ovt job=sendgmr) by 2002:a17:90b:2485:b0:229:f43c:4049 with SMTP id
 nt5-20020a17090b248500b00229f43c4049mr77962pjb.0.1674499200383; Mon, 23 Jan
 2023 10:40:00 -0800 (PST)
Date:   Mon, 23 Jan 2023 18:39:59 +0000
In-Reply-To: <20221227203249.1213526-24-sashal@kernel.org>
Mime-Version: 1.0
References: <20221227203249.1213526-24-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0.246.g2a6d74b583-goog
Message-ID: <20230123183959.3692697-1-ovt@google.com>
Subject: [PATCH AUTOSEL 6.1 24/28] NFSD: fix use-after-free in __nfs42_ssc_open()
From:   Oleksandr Tymoshenko <ovt@google.com>
To:     sashal@kernel.org
Cc:     chuck.lever@oracle.com, dai.ngo@oracle.com, hdthky0@gmail.com,
        jlayton@kernel.org, linux-kernel@vger.kernel.org,
        linux-nfs@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

Does this patch need to be backported to 5.15 and all other supported LTS branches
or only 6.1 is affected?

Thank you
