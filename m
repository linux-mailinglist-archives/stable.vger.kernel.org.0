Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC8F46CAFB0
	for <lists+stable@lfdr.de>; Mon, 27 Mar 2023 22:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231716AbjC0UQB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Mar 2023 16:16:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232417AbjC0UP7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Mar 2023 16:15:59 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EAC3A6
        for <stable@vger.kernel.org>; Mon, 27 Mar 2023 13:15:57 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id z83so12310485ybb.2
        for <stable@vger.kernel.org>; Mon, 27 Mar 2023 13:15:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679948156;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=uIvcDIjHMfUvOFRj+LO1wozFuW9lS+8UFaDeYuBoqV0=;
        b=VPfvQPv94hLQtld1nY8t/kVR1zMp5PMikUjCrrW9IJfb7DGX2Rq0B1nsWyX4UEusES
         6k2uPKYfkn91P65R5bHU7+yj0+XeSBTzmZrhy3zNQyQf6Q5MNoTpxmkfKsAkGk/kRbxE
         5OnBj5+FaYQGqffLxuF1XILjlOqohrV7nqSU1IYxjYOE5g6+UCSY6DG6qZLiC9RjdjqT
         Pc28rburbng2gm2sn/m9uZc7bCpGzSz5nF6ZWtIstCG/PmE2vDkm0WP26h1S5susB2Us
         6PpEyPKBzpbA/s8Xoskf6U/nkyOpGrV75Dt2N26StF4/na0Sz0Y/UteVcMU/AriIH2DC
         mq4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679948156;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uIvcDIjHMfUvOFRj+LO1wozFuW9lS+8UFaDeYuBoqV0=;
        b=b2f+a5MLyf/VwNpKCGSygTbNJ4yLnGkHg/rNQ66GmgjNcLrFWU/Zc3ICS/uHCpyctY
         x3QfM6qNqLrSjvPxingLVolafkfVIV/wg7tEvkan7T2lJegHCh2em1AfKnYcbboORfZk
         iilavkcPOGPg/HHWaeTwPEJ2Fig654WKAEWgR/cc8/nt1qg4s6hwjYnsOQdfF4ZGsN+c
         d6Zz7pq21/ygB9lcFGNSsn8fl8bcipWh5pp0zXwKIz4r4aOXwn2fQ/PmrGc8Qo4I1rt0
         6TxF8DyJXKg2TROFY5sSY6HMdDbV5d9ZXgufqceR0OFOInD/f8spIfIEL9VXCFQ33YNi
         phtg==
X-Gm-Message-State: AAQBX9f1QwW7N07LYiDXaZMPWRWGUkG2xHq+vRnFcsbCD0qxrq4dxorv
        bPv8+pq/mzbZM2+ZC2BYxsYOVinJs7eiey5Oh7c2Vu2eLF0C/WsVUQldefuV
X-Google-Smtp-Source: AKy350Z7F0PUXN2f7qUEFAmcZSLQJlhlAaBS8bKPyscnHoPKIg2Gb1MiovXdYIfUaic80GLCSPw4xKonpL1nzod/ceE=
X-Received: by 2002:a05:6902:1201:b0:b6c:4d60:1bd6 with SMTP id
 s1-20020a056902120100b00b6c4d601bd6mr8517167ybu.9.1679948156478; Mon, 27 Mar
 2023 13:15:56 -0700 (PDT)
MIME-Version: 1.0
From:   Nobel Barakat <nobelbarakat@google.com>
Date:   Mon, 27 Mar 2023 13:15:45 -0700
Message-ID: <CANZXNgPN=yNchM00fn0-7nd5xs_6DEgTFng0zS96J+tGnntynQ@mail.gmail.com>
Subject: 6.1 Backport Request: act_mirred: use the backlog for nested calls to
 mirred ingress
To:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SUBJECT: act_mirred: use the backlog for nested calls to mirred ingress
COMMIT: commit ca22da2fbd693b54dc8e3b7b54ccc9f7e9ba3640

Reason for request:
The commit above resolves CVE-2022-4269.
