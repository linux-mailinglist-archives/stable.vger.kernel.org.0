Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 732D96B0A02
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 14:54:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231820AbjCHNyO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 08:54:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231818AbjCHNxR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 08:53:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7B873E087;
        Wed,  8 Mar 2023 05:53:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D487961812;
        Wed,  8 Mar 2023 13:53:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67893C4339E;
        Wed,  8 Mar 2023 13:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678283592;
        bh=scIBUCibkZ6ezqacbiLi2xkfwIP7lbG0QjO+CwNdsuI=;
        h=From:To:Cc:Subject:Date:From;
        b=cWsn6VcLigVWXFE12TziUl2A+goLVmmqhaU8/hQ1WT38LkiXMswpG0+LJVQdVe0RT
         kq42+k3yNkY/6JKCq0AKCzo8xvw0tgnSoi5JA3TSQaN9jnWmUyjxyLA6F8bGgvaIxs
         xbHMXaGh8ogtYE3GZ+C33iPcfaZ40kpJxHhrkksqMAUiDxba4Pek7pI0qNX8GkYl6U
         eZfassxObD41O+SMSlPce1xhDBbIYECuANHGxVyja0vI17+Vtinc8cKvmwVgVDJAHR
         iKAiVStQF6U6YKT5KNYiI+9JWZ5jey0XJfg/bCHpsG+yf1fo1fduDnJuDwpEWhTELa
         qfNMziOjoMgIA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nicolas Schier <nicolas@fjasle.eu>,
        Sasha Levin <sashal@kernel.org>, nathan@kernel.org,
        llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 5.10 1/3] scripts: handle BrokenPipeError for python scripts
Date:   Wed,  8 Mar 2023 08:53:04 -0500
Message-Id: <20230308135309.2927462-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 87c7ee67deb7fce9951a5f9d80641138694aad17 ]

In the follow-up of commit fb3041d61f68 ("kbuild: fix SIGPIPE error
message for AR=gcc-ar and AR=llvm-ar"), Kees Cook pointed out that
tools should _not_ catch their own SIGPIPEs [1] [2].

Based on his feedback, LLVM was fixed [3].

However, Python's default behavior is to show noisy bracktrace when
SIGPIPE is sent. So, scripts written in Python are basically in the
same situation as the buggy llvm tools.

Example:

  $ make -s allnoconfig
  $ make -s allmodconfig
  $ scripts/diffconfig .config.old .config | head -n1
  -ALIX n
  Traceback (most recent call last):
    File "/home/masahiro/linux/scripts/diffconfig", line 132, in <module>
      main()
    File "/home/masahiro/linux/scripts/diffconfig", line 130, in main
      print_config("+", config, None, b[config])
    File "/home/masahiro/linux/scripts/diffconfig", line 64, in print_config
      print("+%s %s" % (config, new_value))
  BrokenPipeError: [Errno 32] Broken pipe

Python documentation [4] notes how to make scripts die immediately and
silently:

  """
  Piping output of your program to tools like head(1) will cause a
  SIGPIPE signal to be sent to your process when the receiver of its
  standard output closes early. This results in an exception like
  BrokenPipeError: [Errno 32] Broken pipe. To handle this case,
  wrap your entry point to catch this exception as follows:

    import os
    import sys

    def main():
        try:
            # simulate large output (your code replaces this loop)
            for x in range(10000):
                print("y")
            # flush output here to force SIGPIPE to be triggered
            # while inside this try block.
            sys.stdout.flush()
        except BrokenPipeError:
            # Python flushes standard streams on exit; redirect remaining output
            # to devnull to avoid another BrokenPipeError at shutdown
            devnull = os.open(os.devnull, os.O_WRONLY)
            os.dup2(devnull, sys.stdout.fileno())
            sys.exit(1)  # Python exits with error code 1 on EPIPE

    if __name__ == '__main__':
        main()

  Do not set SIGPIPE’s disposition to SIG_DFL in order to avoid
  BrokenPipeError. Doing that would cause your program to exit
  unexpectedly whenever any socket connection is interrupted while
  your program is still writing to it.
  """

Currently, tools/perf/scripts/python/intel-pt-events.py seems to be the
only script that fixes the issue that way.

tools/perf/scripts/python/compaction-times.py uses another approach
signal.signal(signal.SIGPIPE, signal.SIG_DFL) but the Python
documentation clearly says "Don't do it".

I cannot fix all Python scripts since there are so many.
I fixed some in the scripts/ directory.

[1]: https://lore.kernel.org/all/202211161056.1B9611A@keescook/
[2]: https://github.com/llvm/llvm-project/issues/59037
[3]: https://github.com/llvm/llvm-project/commit/4787efa38066adb51e2c049499d25b3610c0877b
[4]: https://docs.python.org/3/library/signal.html#note-on-sigpipe

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Nicolas Schier <nicolas@fjasle.eu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/checkkconfigsymbols.py         | 13 ++++++++++++-
 scripts/clang-tools/run-clang-tools.py | 21 ++++++++++++++-------
 scripts/diffconfig                     | 16 ++++++++++++++--
 3 files changed, 40 insertions(+), 10 deletions(-)

diff --git a/scripts/checkkconfigsymbols.py b/scripts/checkkconfigsymbols.py
index 1548f9ce46827..697972432bbe7 100755
--- a/scripts/checkkconfigsymbols.py
+++ b/scripts/checkkconfigsymbols.py
@@ -113,7 +113,7 @@ def parse_options():
     return args
 
 
-def main():
+def print_undefined_symbols():
     """Main function of this module."""
     args = parse_options()
 
@@ -472,5 +472,16 @@ def parse_kconfig_file(kfile):
     return defined, references
 
 
+def main():
+    try:
+        print_undefined_symbols()
+    except BrokenPipeError:
+        # Python flushes standard streams on exit; redirect remaining output
+        # to devnull to avoid another BrokenPipeError at shutdown
+        devnull = os.open(os.devnull, os.O_WRONLY)
+        os.dup2(devnull, sys.stdout.fileno())
+        sys.exit(1)  # Python exits with error code 1 on EPIPE
+
+
 if __name__ == "__main__":
     main()
diff --git a/scripts/clang-tools/run-clang-tools.py b/scripts/clang-tools/run-clang-tools.py
index f754415af398b..f42699134f1c0 100755
--- a/scripts/clang-tools/run-clang-tools.py
+++ b/scripts/clang-tools/run-clang-tools.py
@@ -60,14 +60,21 @@ def run_analysis(entry):
 
 
 def main():
-    args = parse_arguments()
+    try:
+        args = parse_arguments()
 
-    lock = multiprocessing.Lock()
-    pool = multiprocessing.Pool(initializer=init, initargs=(lock, args))
-    # Read JSON data into the datastore variable
-    with open(args.path, "r") as f:
-        datastore = json.load(f)
-        pool.map(run_analysis, datastore)
+        lock = multiprocessing.Lock()
+        pool = multiprocessing.Pool(initializer=init, initargs=(lock, args))
+        # Read JSON data into the datastore variable
+        with open(args.path, "r") as f:
+            datastore = json.load(f)
+            pool.map(run_analysis, datastore)
+    except BrokenPipeError:
+        # Python flushes standard streams on exit; redirect remaining output
+        # to devnull to avoid another BrokenPipeError at shutdown
+        devnull = os.open(os.devnull, os.O_WRONLY)
+        os.dup2(devnull, sys.stdout.fileno())
+        sys.exit(1)  # Python exits with error code 1 on EPIPE
 
 
 if __name__ == "__main__":
diff --git a/scripts/diffconfig b/scripts/diffconfig
index d5da5fa05d1d3..43f0f3d273ae7 100755
--- a/scripts/diffconfig
+++ b/scripts/diffconfig
@@ -65,7 +65,7 @@ def print_config(op, config, value, new_value):
         else:
             print(" %s %s -> %s" % (config, value, new_value))
 
-def main():
+def show_diff():
     global merge_style
 
     # parse command line args
@@ -129,4 +129,16 @@ def main():
     for config in new:
         print_config("+", config, None, b[config])
 
-main()
+def main():
+    try:
+        show_diff()
+    except BrokenPipeError:
+        # Python flushes standard streams on exit; redirect remaining output
+        # to devnull to avoid another BrokenPipeError at shutdown
+        devnull = os.open(os.devnull, os.O_WRONLY)
+        os.dup2(devnull, sys.stdout.fileno())
+        sys.exit(1)  # Python exits with error code 1 on EPIPE
+
+
+if __name__ == '__main__':
+    main()
-- 
2.39.2

