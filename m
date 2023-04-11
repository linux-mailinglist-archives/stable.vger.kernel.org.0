Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBF586DE5D7
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 22:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbjDKUm2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 16:42:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbjDKUm1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 16:42:27 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DC9546B8
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 13:42:24 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id q5so5290987wmo.4
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 13:42:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1681245743;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yLw+Q9jRLjBSRcIOCrWWTPAtbf14hoPj7TuOVMiOlaQ=;
        b=iwDG2NgSrNS+WGzysNtYXdJWA3DWB5fN9hnDIvSQ7oEhhsJ3RsK9NbJZ0cX220bwv0
         BvQq2vugPGpeh0O9c7YrZoJ/YWhSmvwF+oAAwt/wM1Sud9nUZXb2y92LzcpI8RuPiSzN
         7KPENpWrf0c9DT4/Z4CFoNgCWii5AfQRz4/BNwpDwB1Tzv+jhdJ9hk1s2u4db5Njb/Kb
         hd7uPsIbpx9qyw8xQ0xeyM9m/OoHkooeUuDCafenat9bAhKjc09NJpfRE9CYoQeq8JKG
         ogONEPJIjDnQvfxXBNiGQF1ms3oDWJ/cWs3UhUmI5xBidabHaaZM0eqC5N0+fvVMZTVY
         Y6FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681245743;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yLw+Q9jRLjBSRcIOCrWWTPAtbf14hoPj7TuOVMiOlaQ=;
        b=RkopUSnl5JL13pnw9+yz3T5Bp5CVgjQofR6QIrddserDGk9wNdhOVA1enHH4kY0osc
         ulxaDlw9cKetN0+IX94zd6dEOJxflxL5+Pp3VTaB7nPvEoR307LiGkxIPmc0UYeUnxp5
         yfFwBDM/pWMSP55dbsoEIrndTvKMCQ6u+V1P+K5jZUPQJBRVhZ78GJN8BcfPJ3sRc280
         meoD48uVMuLg9juaIMqBIRVFp9KPn7qvllY6aAJI+od7w17CA8BaSlYD6O89J8x9ONas
         IkzdJvd3glcbLqBdaPfqlUZrm1qGMffi6zl2BV2F0/Dg7IHjV3W6Z1PLXYMN9Dljklsx
         OObQ==
X-Gm-Message-State: AAQBX9fCuTk6g7GlPhwnMbLwdn6LUmOon1fp9w6qPyhUeSBQDUVrMdTb
        /ePPqRqs5ZsEH5MvsyIW4SiKkYWmVfhZzSHPCqc1nw==
X-Google-Smtp-Source: AKy350ZrPZmJoZzqx9ha+ZRrg8c0OK5tUwNwVi2LISl/wtLxuyv+DaURwvKXSo4+X1d2wgHnRrozcg==
X-Received: by 2002:a05:600c:2158:b0:3eb:3945:d405 with SMTP id v24-20020a05600c215800b003eb3945d405mr2959574wml.38.1681245743301;
        Tue, 11 Apr 2023 13:42:23 -0700 (PDT)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id p23-20020a1c7417000000b003f0824e8c92sm86887wmc.7.2023.04.11.13.42.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 13:42:22 -0700 (PDT)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: [PATCH net 0/4] mptcp: more fixes for 6.3
Date:   Tue, 11 Apr 2023 22:42:08 +0200
Message-Id: <20230411-upstream-net-20230411-mptcp-fixes-v1-0-ca540f3ef986@tessares.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIACDGNWQC/z2MSw7CMAxEr1J5jUUSClRcBbHIx6VeJERxqJCq3
 p2EBcs3M282ECpMArdhg0IrC79SA30YwC82PQk5NAajzEmNWuM7Sy1kIyaq+E9jrj7jzB8SDG6
 8zmflzWWaoP04K4Su2OSX/tS8QGvXj9Fy6otc6Ke2+t57eOz7Fx+OcKCaAAAA
To:     mptcp@lists.linux.dev, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Dmytro Shytyi <dmytro@shytyi.net>,
        Shuah Khan <shuah@kernel.org>,
        Mat Martineau <martineau@kernel.org>,
        Geliang Tang <geliang.tang@suse.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        stable@vger.kernel.org, Christoph Paasch <cpaasch@apple.com>
X-Mailer: b4 0.12.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1437;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=Qu/CYuD3UnLcvbNoUFhk1/XXHx+nZOplbse+R6F1NLM=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBkNcYtnYL2zHzJFK+uDtjyJTHmad+2rXZzpVUjM
 eFGVz9GlRCJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCZDXGLQAKCRD2t4JPQmmg
 c5k6EACNWOxesNG8X52d6QRhRwdefUPp7R4Czldp5iiZQ4qb8XfwvNgWAZzHB06N3RC3ZCu4hr7
 Po94OYc7661HCvz8qt3FqOA7h8sHiXnbQb3EP1M9sBBuFKIPkfsFUhNV57o0NWW1gp9t4xpYkqn
 xcB3CIucSjNbAn+/kmxsouoplTWO1uH1/AOhUTfaddzh5feu2nceaRv7joBN+qrbtJ391Bwt6Yc
 QafFlJHyNxHj8+JNOpZYOCkX5X3QEuLxNr+GrrASTsCxFTFdSL/Zfr1MM6WlBkCE3bkq65ICfPA
 hqlD9Fx6ranlJFlmhUHeaLMe9ydLYKjcsVfVp7ve6c2ArU4WNec7huUq+bRSNj0l85CKI9te8FE
 F0XuIzCtxkTJVsjfZV0PDcRuP19hb8kTVh1GyRvL1xSkFL+5nws8Ak6Q+y+E9gIRDcCxAWAsxSX
 MPM4pHPe+3gTknlM9DtqDqqjIK+bCfWAGHmMGIYc2pw8rdlqEBvQCx6jhxADWlpwtfW81bNVQei
 8z2S+Nts6HEyiBgbBY4tYK0JBFzk4RAe5sCPX9gD91xIQ7syIvNWg9sp/AQ9ulpAdsuSiIcRoeo
 mNx2xb1eyMnJ+LgZnGkYVLLgEzP+07LE49fa9knC6AcSo+n9Y8MdFWC7QrdsPwUMoCvxRmwA6tk
 T9CwhvWbi4zB54g==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp;
 fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Patch 1 avoids scheduling the MPTCP worker on a closed socket on some
edge cases. It fixes issues that can be visible from v5.11.

Patch 2 makes sure the MPTCP worker doesn't try to manipulate
disconnected sockets. This is also a fix for an issue that can be
visible from v5.11.

Patch 3 fixes a NULL pointer dereference when MPTCP FastOpen is used
and an early fallback is done. A fix for v6.2.

Patch 4 improves the stability of the userspace PM selftest for a
subtest added in v6.2.

Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
Matthieu Baerts (1):
      selftests: mptcp: userspace pm: uniform verify events

Paolo Abeni (3):
      mptcp: use mptcp_schedule_work instead of open-coding it
      mptcp: stricter state check in mptcp_worker
      mptcp: fix NULL pointer dereference on fastopen early fallback

 net/mptcp/fastopen.c                              | 11 +++++++++--
 net/mptcp/options.c                               |  5 ++---
 net/mptcp/protocol.c                              |  2 +-
 net/mptcp/subflow.c                               | 18 ++++++------------
 tools/testing/selftests/net/mptcp/userspace_pm.sh |  2 ++
 5 files changed, 20 insertions(+), 18 deletions(-)
---
base-commit: a4506722dc39ca840593f14e3faa4c9ba9408211
change-id: 20230411-upstream-net-20230411-mptcp-fixes-db47f50c2688

Best regards,
-- 
Matthieu Baerts <matthieu.baerts@tessares.net>

