Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D21E26968C0
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 17:05:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230162AbjBNQFg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 11:05:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbjBNQFf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 11:05:35 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 353332711
        for <stable@vger.kernel.org>; Tue, 14 Feb 2023 08:05:33 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id n33so5296491wms.0
        for <stable@vger.kernel.org>; Tue, 14 Feb 2023 08:05:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=koohUOzc3rjrd3gVo0FWEGT8TyvX1unyQ4Ov4ky2KxY=;
        b=ezar0RbmXvGadURMmsgoHqS5UwCpOY4/xRvW9tk4MUUE6qnooytNWC1Q4jjOa3Pmwi
         eJDcWj2/IQJXO1bJOLjkoW5wFOVsuMe4ekd2ZyUr/wsai2Lb8Y/xQfcALH2qP6BySKKV
         NmMnJOcC0Qvt56vU3ZwQW8nmNHN88lFb5My0CHi2jFRn80KY8H0o/PE4S8lt9YIFXwLg
         nBZtkiBa0g+PB0r+nw7kH1HjZB3vcdDyMWwH//fGjDe7jnbYk+Kr/vxpCzTZUAxkELCE
         0K+OtGfvL/PuHEkYzTBcSYM54uZTGgXQM/pOwdpftVpC6gE/G8/TIG3S6d/xo3LP9aj9
         wOqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=koohUOzc3rjrd3gVo0FWEGT8TyvX1unyQ4Ov4ky2KxY=;
        b=pLU3BYGSJiqMOibN3iEIlvV0OB/hYMYuUI9Ae8hCkl4Uo6MJ1nSlLqH1pG5sg+KsKi
         0iKrTOhXuHqyEXyKVDlRG/L8QoAN0lSaV8dC7XsstNMdtCnEV+uveckbap0AT7MdxUuq
         lnmEHsGyw/1MP4LLKf1EuWnuY4z+4+qh5CcBtbL5qNqtoPwPdFyGRro5htbeGVhoL/MJ
         2/foLiDTc0uaSHz/+YaShSct+cm3m3L+ca8PIn5wN5gNg+7bi7QljkMC6PmfzB5LStAF
         Fje6ciZZ4JemplCxKzBJg/hFigo4xCBLCphtE7xCyhVhWPSMUmRWG4oo3CkxIQ5TcROu
         +0cg==
X-Gm-Message-State: AO0yUKUq6IMIJOn+w/qejZjn2Ez4XZB3iAQSidA31MwvT2wFbqiR0Xb1
        d4w7HSEmsGSOT0IoSTxPWoTgcg==
X-Google-Smtp-Source: AK7set9Av7L6grWHige91KlE2d/GnFM04OOwqDW8qWWoB91apgCCJeh4yyq/B8Ly9x+X+KF13pc2SA==
X-Received: by 2002:a05:600c:1893:b0:3dc:4cb5:41c with SMTP id x19-20020a05600c189300b003dc4cb5041cmr2343832wmp.0.1676390731757;
        Tue, 14 Feb 2023 08:05:31 -0800 (PST)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id bg30-20020a05600c3c9e00b003db012d49b7sm4435537wmb.2.2023.02.14.08.05.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 08:05:31 -0800 (PST)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Date:   Tue, 14 Feb 2023 17:05:10 +0100
Subject: [PATCH 6.1 4/4] selftests: mptcp: userspace: fix v4-v6 test in
 v6.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230214-upstream-stable-20230214-linux-6-1-12-rc1-mptcp-fixes-v1-4-02f36fa30f8c@tessares.net>
References: <20230214-upstream-stable-20230214-linux-6-1-12-rc1-mptcp-fixes-v1-0-02f36fa30f8c@tessares.net>
In-Reply-To: <20230214-upstream-stable-20230214-linux-6-1-12-rc1-mptcp-fixes-v1-0-02f36fa30f8c@tessares.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>, stable@vger.kernel.org,
        mptcp@lists.linux.dev,
        Matthieu Baerts <matthieu.baerts@tessares.net>
X-Mailer: b4 0.12.1
X-Developer-Signature: v=1; a=openpgp-sha256; l=2149;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=SmWA3FfTQrdAQe5yh2fWIfTfIMgI4aRmQCw9PfjZtg8=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBj67FHtzAQM2XHOno/T9eG7WW2rME9eHlHJv9JW
 jorwRbL/NeJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCY+uxRwAKCRD2t4JPQmmg
 c6SfD/9t1cdsl3PoFAZAjnJGng3cDWJx1rnsIJyQE55YF0cdFCSYuxv3XGgyVVBGs78+FUqpS0n
 mVck4LqsDy4i5LFDKzjMCkzph0kewhA0V3CfcQO5iG2nvyaanXqDGoAhqNI+chU5uTLrF6Ax6k6
 hzKqBYAImEECjiwyrOSfhhOc/JxqmRZjn/kkQwI5eQah0IuCAfgAJczFgt5KNEkOrlQc5d9tUeQ
 G+vhz6meBV8/poBpby3+yuY0amgzGuvgWbkJhgTbMXYWgGcECFJVwehoSBo5NPOoeQGsNbM6pud
 VkqTb/wp5ss7ai+RPn2QwC/O5y0TW2/7ceBAR1C5MBpiS0S3K2DzBqbs7CP8CsgyqItRDI7yjkC
 VMEIuoFKssTflZN6xQZUeSWVNSvbzbRh3dHckGIxBnccDK7BwNtL6WukRSnknIv3CjAYFmdZ524
 ZXFDWfQFxz+egzx7tMAyZy23iXV7XumrMzG7puTSngpPGT3BuYSxdBJ0gwkvBbrbbdhpvoCTfu3
 Q7kJsFblUcC7QzscFCu1KEprt10PjH30N8/Zu6902I7eYyEF84Y7p0A1Otj75pZrRAUsYEBHybE
 UfBv/TZm+uVu/i1SpNjAmbTiawsnc2rUPuIdZWcy0wzUtvNbAsisl40lxmIk+s0IhGiCU5DWoPY
 FwNN7N8T972HqSw==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp;
 fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The commit 4656d72c1efa ("selftests: mptcp: userspace: validate v4-v6 subflows mix")
has been backported to v6.1.8 without any conflicts. But it looks like
it was depending on a previous one:

  commit 1cc94ac1af4b ("selftests: mptcp: make evts global in userspace_pm")

Without it, the test fails with:

  ./userspace_pm.sh: line 788: : No such file or directory
  # ADD_ADDR4 id:14 10.0.2.1 (ns1) => ns2, reuse port        [FAIL]
  sed: can't read : No such file or directory

This dependence refactors the way the monitoring files are being
created: only once for all the different sub-tests instead of per
sub-test.

It is probably better to avoid backporting the refactoring. That is why
the new sub-test has been adapted to work using the previous way that is
still in place here in v6.1: the monitoring is started at the beginning
of each sub-test and the created file is removed at the end.

Fixes: f59549814a64 ("selftests: mptcp: userspace: validate v4-v6 subflows mix")
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 tools/testing/selftests/net/mptcp/userspace_pm.sh | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/tools/testing/selftests/net/mptcp/userspace_pm.sh b/tools/testing/selftests/net/mptcp/userspace_pm.sh
index 0040e3bc7b16..ad6547c79b83 100755
--- a/tools/testing/selftests/net/mptcp/userspace_pm.sh
+++ b/tools/testing/selftests/net/mptcp/userspace_pm.sh
@@ -778,6 +778,14 @@ test_subflows()
 
 test_subflows_v4_v6_mix()
 {
+	local client_evts
+	client_evts=$(mktemp)
+	# Capture events on the network namespace running the client
+	:>"$client_evts"
+	ip netns exec "$ns2" ./pm_nl_ctl events >> "$client_evts" 2>&1 &
+	evts_pid=$!
+	sleep 0.5
+
 	# Attempt to add a listener at 10.0.2.1:<subflow-port>
 	ip netns exec "$ns1" ./pm_nl_ctl listen 10.0.2.1\
 	   $app6_port > /dev/null 2>&1 &
@@ -820,6 +828,9 @@ test_subflows_v4_v6_mix()
 	ip netns exec "$ns1" ./pm_nl_ctl rem id $server_addr_id token\
 	   "$server6_token" > /dev/null 2>&1
 	sleep 0.5
+
+	kill_wait $evts_pid
+	rm -f "$client_evts"
 }
 
 test_prio()

-- 
2.38.1

